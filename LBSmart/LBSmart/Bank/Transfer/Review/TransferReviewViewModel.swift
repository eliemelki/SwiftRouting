import Combine
import Foundation

@MainActor
final class TransferReviewViewModel: ObservableObject {
    private let editor: TransferDraftEditor
    private var subscription: AnyCancellable?

    var draft: TransferDraft {
        editor.draft
    }

    private let coordinator: any TransferReviewCoordinator

    var validationMessage: String? {
        editor.validationMessage
    }

    var amount: Decimal? {
        editor.amount
    }

    var canConfirm: Bool {
        validationMessage == nil && draft.receipt == nil
    }

    init(draft: TransferDraft, coordinator: any TransferReviewCoordinator) {
        self.coordinator = coordinator
        self.editor = TransferDraftEditor(draft: draft)
        subscription = draft.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
        }
    }

    func setRecipient(_ recipient: String) {
        guard draft.receipt == nil else {
            return
        }
        draft.recipient = recipient
    }

    func setAmount(_ amount: String) {
        guard draft.receipt == nil else {
            return
        }
        draft.amountText = amount
    }

    func setReference(_ reference: String) {
        guard draft.receipt == nil else {
            return
        }
        draft.reference = reference
    }

    func edit() {
        guard draft.receipt == nil else {
            return
        }
        coordinator.editTransfer()
    }

    func confirm() {
        guard canConfirm, let amount else {
            return
        }
        let receipt = TransferReceipt(
            id: UUID(),
            sourceAccount: draft.sourceAccount,
            recipient: draft.recipient.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            reference: draft.reference.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        draft.receipt = receipt
        coordinator.showConfirmation(draft, receipt: receipt)
    }

    func cancel() {
        editor.resetDraft()
        coordinator.returnToDetails()
    }
}
