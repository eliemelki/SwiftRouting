import Combine
import Foundation
import Testing

@testable import LBSmart

@MainActor
private func reviewDraft(from coordinator: TransferCoordinator) throws -> TransferDraft {
    let draft: TransferDraft?
    if case .review(let value) = coordinator.navigationRouter.path.last?.route {
        draft = value
    } else {
        draft = nil
    }
    return try #require(draft)
}

@MainActor
@Test func testTransferIsThirdTabAndProfileIsFourth() throws {
    let app = BankAppCoordinator()
    app.signIn()
    let session = try #require(app.tabCoordinator)
    #expect(session.tabRouter.tabs.map(\.route) == [.accounts, .cards, .transfer, .profile])
}

@MainActor
@Test func testTransferScreensShareOneModelAndReviewEditsSurviveBack() throws {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.selectAccount(BankAccount.samples[1])
    details.setRecipient("Jamie")
    details.setAmount("125.50")
    details.setReference("Dinner")
    let snapshot = details.draft
    details.review()
    let draft = try reviewDraft(from: coordinator)
    let review = TransferReviewViewModel(draft: draft, coordinator: coordinator)
    #expect(review.draft === snapshot)
    review.setRecipient("Taylor")
    review.setAmount("80.25")
    review.setReference("Updated in review")
    #expect(snapshot.recipient == "Taylor")
    #expect(snapshot.amountText == "80.25")
    #expect(snapshot.reference == "Updated in review")
    #expect(draft.reference == "Updated in review")
    #expect(review.draft.reference == "Updated in review")
    #expect(details.draft.recipient == "Taylor")
    #expect(details.draft.amountText == "80.25")
    #expect(details.draft.reference == "Updated in review")
    // Both screens observe the same model before the standard back action.
    coordinator.navigationRouter.popLast(animated: false)
    #expect(details.draft.recipient == "Taylor")
    #expect(details.draft.amountText == "80.25")
    #expect(details.draft.reference == "Updated in review")
    details.setAmount("75.25")
    details.review()
    let secondReview = TransferReviewViewModel(draft: try reviewDraft(from: coordinator), coordinator: coordinator)
    #expect(secondReview.amount == Decimal(string: "75.25"))
    #expect(review.amount == Decimal(string: "75.25"))
    secondReview.edit()
    #expect(coordinator.navigationRouter.path.isEmpty)
}

@MainActor
@Test func testConfirmationCarriesCompletedValuesAndResetReturnsToDetails() throws {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setRecipient(" Jamie ")
    details.setAmount("100.01")
    details.setReference(" Gift ")
    details.review()
    details.review()
    #expect(coordinator.navigationRouter.path.count == 1)
    let review = TransferReviewViewModel(draft: try reviewDraft(from: coordinator), coordinator: coordinator)
    review.confirm()
    guard case .confirmation(let draft, let receipt) = coordinator.navigationRouter.path.last?.route else {
        Issue.record("Expected confirmation with completed values")
        return
    }
    let confirmation = TransferConfirmationViewModel(draft: draft, receipt: receipt, coordinator: coordinator)
    #expect(confirmation.receipt.recipient == "Jamie")
    #expect(confirmation.receipt.amount == Decimal(string: "100.01"))
    #expect(confirmation.receipt.reference == "Gift")
    #expect(confirmation.draft === review.draft)
    #expect(details.draft.receipt == receipt)
    review.confirm()
    #expect(coordinator.navigationRouter.path.count == 2)
    details.setAmount("200")
    #expect(details.draft.amountText == "100.01")
    #expect(!details.canReview)
    #expect(!review.canConfirm)
    confirmation.startNewTransfer()
    #expect(coordinator.navigationRouter.path.isEmpty)
    expectFreshDraft(details.draft)
    expectFreshDraft(confirmation.draft)
    // The receipt remains visible while the confirmation view animates away.
    #expect(confirmation.receipt == receipt)
}

@MainActor
@Test(arguments: ["", "0", "-1", "1.001", "abc", "1e2", "NaN", "Infinity", "4,000", "5000"])
func testTransferRejectsInvalidAmounts(_ amount: String) {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setRecipient("Jamie")
    details.setAmount(amount)
    details.review()
    #expect(!details.canReview)
    #expect(details.validationMessage != nil)
    #expect(coordinator.navigationRouter.path.isEmpty)
    #expect(details.draft.receipt == nil)
}

@MainActor
@Test func testTransferRequiresRecipientAndRevalidatesAccountBalance() {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setAmount("5000")
    details.setRecipient(" \n ")
    details.selectAccount(BankAccount.samples[1])
    #expect(!details.canReview)
    details.setRecipient("Jamie")
    #expect(details.canReview)
    details.selectAccount(BankAccount.samples[0])
    #expect(!details.canReview)
    details.review()
    #expect(coordinator.navigationRouter.path.isEmpty)
    details.setAmount("4280.50")
    #expect(details.canReview)
}

@MainActor
@Test func testCancellingReviewResetsSharedModel() throws {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.selectAccount(BankAccount.samples[1])
    details.setRecipient("Jamie")
    details.setAmount("25")
    details.setReference("Lunch")
    details.review()
    let review = TransferReviewViewModel(draft: try reviewDraft(from: coordinator), coordinator: coordinator)
    review.cancel()
    #expect(coordinator.navigationRouter.path.isEmpty)
    expectFreshDraft(details.draft)
    expectFreshDraft(review.draft)
    details.setRecipient("Another recipient")
    details.cancel()
    expectFreshDraft(details.draft)
}

@MainActor
@Test func testTransferSurvivesTabSwitchAndNewSessionStartsEmpty() throws {
    let app = BankAppCoordinator()
    app.signIn()
    let session = try #require(app.tabCoordinator)
    let coordinator = session.transferCoordinator
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setRecipient("Jamie")
    details.setAmount("10")
    details.review()
    session.tabRouter.select(.profile)
    session.tabRouter.select(.transfer)
    #expect(try reviewDraft(from: coordinator).draft.recipient == "Jamie")
    #expect(details.draft.recipient == "Jamie")
    #expect(session.accountsCoordinator.navigationRouter.path.isEmpty)
    #expect(session.cardsCoordinator.navigationRouter.path.isEmpty)
    app.signOut()
    app.signIn()
    let fresh = try #require(app.tabCoordinator?.transferCoordinator)
    #expect(fresh !== coordinator)
    expectFreshDraft(TransferDetailsViewModel(coordinator: fresh).draft)
    #expect(fresh.navigationRouter.path.isEmpty)
}

@MainActor
@Test func testPassingDraftDoesNotRetainDetailsViewModel() throws {
    let coordinator = TransferCoordinator()
    var details: TransferDetailsViewModel? = TransferDetailsViewModel(coordinator: coordinator)
    details?.setRecipient("Jamie")
    details?.setAmount("10")
    details?.review()
    let draft = try reviewDraft(from: coordinator)
    weak var weakDetails = details
    details = nil
    #expect(weakDetails == nil)
    let review = TransferReviewViewModel(draft: draft, coordinator: coordinator)
    review.setReference("Safe after Details is released")
    #expect(review.draft.reference == "Safe after Details is released")
}

@MainActor
private final class TransferCoordinatorSpy: TransferDetailsCoordinator,
    TransferReviewCoordinator, TransferConfirmationCoordinator {
    private(set) var drafts: [TransferDraft] = []
    private(set) var confirmations: [(TransferDraft, TransferReceipt)] = []
    private(set) var returns = 0

    func reviewTransfer(_ draft: TransferDraft) {
        drafts.append(draft)
    }

    func editTransfer() {
        returns += 1
    }

    func showConfirmation(_ draft: TransferDraft, receipt: TransferReceipt) {
        confirmations.append((draft, receipt))
    }

    func returnToDetails() {
        returns += 1
    }
}

@MainActor
@Test func testTransferBusinessLogicWorksWithoutNavigationRouter() throws {
    let coordinator = TransferCoordinatorSpy()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.review()
    #expect(coordinator.drafts.isEmpty)
    details.setRecipient(" Jamie ")
    details.setAmount("42.15")
    details.setReference(" Gift ")
    details.review()
    let draft = try #require(coordinator.drafts.first)
    let review = TransferReviewViewModel(draft: draft, coordinator: coordinator)
    review.confirm()
    review.confirm()
    let (confirmationDraft, receipt) = try #require(coordinator.confirmations.first)
    #expect(coordinator.confirmations.count == 1)
    #expect(receipt.recipient == "Jamie")
    #expect(receipt.reference == "Gift")
    #expect(receipt.amount == Decimal(string: "42.15"))
    #expect(details.draft.receipt == receipt)
    let confirmation = TransferConfirmationViewModel(draft: confirmationDraft, receipt: receipt, coordinator: coordinator)
    confirmation.startNewTransfer()
    expectFreshDraft(details.draft)
    #expect(coordinator.returns == 1)
    #expect(confirmation.receipt == receipt)
}

@MainActor
@Test func testReviewEditsRevalidateAndConfirmationUsesUpdatedValues() throws {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setRecipient("Jamie")
    details.setAmount("10")
    details.review()
    let review = TransferReviewViewModel(draft: try reviewDraft(from: coordinator), coordinator: coordinator)
    review.setAmount("5000")
    #expect(!review.canConfirm)
    #expect(details.draft.amountText == "5000")
    review.confirm()
    #expect(coordinator.navigationRouter.path.count == 1)
    review.setAmount("20.50")
    review.setRecipient(" ")
    #expect(!review.canConfirm)
    review.setRecipient("Taylor")
    review.setReference("Changed on review")
    #expect(review.canConfirm)
    review.confirm()
    guard case .confirmation(_, let receipt) = coordinator.navigationRouter.path.last?.route else {
        Issue.record("Expected updated receipt")
        return
    }
    #expect(receipt.recipient == "Taylor")
    #expect(receipt.amount == Decimal(string: "20.50"))
    #expect(receipt.reference == "Changed on review")
    #expect(details.draft.receipt == receipt)
}

@MainActor
private func expectFreshDraft(_ draft: TransferDraft) {
    #expect(draft.sourceAccount == BankAccount.samples[0])
    #expect(draft.recipient.isEmpty)
    #expect(draft.amountText.isEmpty)
    #expect(draft.reference.isEmpty)
    #expect(draft.receipt == nil)
}

@MainActor
@Test func testIndependentTransferViewModelsPublishSharedDraftChanges() throws {
    let coordinator = TransferCoordinator()
    let details = TransferDetailsViewModel(coordinator: coordinator)
    details.setRecipient("Jamie")
    details.setAmount("10")
    details.review()
    let review = TransferReviewViewModel(draft: try reviewDraft(from: coordinator), coordinator: coordinator)
    var detailsChanges = 0
    var reviewChanges = 0
    let detailsSubscription = details.objectWillChange.sink {
        detailsChanges += 1
    }
    let reviewSubscription = review.objectWillChange.sink {
        reviewChanges += 1
    }
    review.setReference("Shared edit")
    #expect(detailsChanges == 1)
    #expect(reviewChanges == 1)
    #expect(details.draft.reference == "Shared edit")
    #expect(review.draft === details.draft)
    detailsSubscription.cancel()
    reviewSubscription.cancel()
}

@MainActor
@Test func testTransferRoutesKeepIdentityWhenDraftChanges() {
    let draft = TransferDraft()
    let route = TransferRoute.review(draft)
    let routes: Set<TransferRoute> = [route]
    draft.recipient = "Updated recipient"
    draft.amountText = "25"
    #expect(routes.contains(.review(draft)))
    #expect(!routes.contains(.review(TransferDraft())))
    #expect(TransferRoute.review(draft) == route)
}
