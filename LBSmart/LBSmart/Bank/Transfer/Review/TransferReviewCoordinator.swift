@MainActor
protocol TransferReviewCoordinator: AnyObject {
    func editTransfer()
    func showConfirmation(_ draft: TransferDraft, receipt: TransferReceipt)
    func returnToDetails()
}
