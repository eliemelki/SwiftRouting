@MainActor
protocol TransferDetailsCoordinator: AnyObject {
    func reviewTransfer(_ draft: TransferDraft)
    func returnToDetails()
}
