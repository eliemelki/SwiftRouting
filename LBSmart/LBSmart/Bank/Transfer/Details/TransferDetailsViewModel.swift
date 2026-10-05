import Combine
import SwiftUI

@MainActor
final class TransferDetailsViewModel: ObservableObject {
    let accounts = BankAccount.samples
    private let editor: TransferDraftEditor
    private var subscription: AnyCancellable?

    var draft: TransferDraft {
        editor.draft
    }

    private let coordinator: any TransferDetailsCoordinator

    var validationMessage: String? {
        editor.validationMessage
    }

    var canReview: Bool {
        validationMessage == nil && draft.receipt == nil
    }

    init(coordinator: any TransferDetailsCoordinator) {
        self.coordinator = coordinator
        self.editor = TransferDraftEditor(draft: TransferDraft())
        subscription = draft.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
        }
    }

    func selectAccount(_ account: BankAccount) {
        guard draft.receipt == nil, accounts.contains(account) else {
            return
        }
        draft.sourceAccount = account
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

    func review() {
        guard canReview else {
            return
        }
        coordinator.reviewTransfer(draft)
    }

    func cancel() {
        editor.resetDraft()
        coordinator.returnToDetails()
    }

}
