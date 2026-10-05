import Combine
import Foundation

@MainActor
final class TransferConfirmationViewModel: ObservableObject {
    let receipt: TransferReceipt
    private let editor: TransferDraftEditor
    private var subscription: AnyCancellable?

    var draft: TransferDraft {
        editor.draft
    }

    private let coordinator: any TransferConfirmationCoordinator

    init(draft: TransferDraft, receipt: TransferReceipt, coordinator: any TransferConfirmationCoordinator) {
        self.receipt = receipt
        self.coordinator = coordinator
        self.editor = TransferDraftEditor(draft: draft)
        subscription = draft.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
        }
    }

    func startNewTransfer() {
        editor.resetDraft()
        coordinator.returnToDetails()
    }
}
