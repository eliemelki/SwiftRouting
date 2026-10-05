import SwiftRouting
import SwiftUI

enum TransferRoute: Route {
    case details
    case review(TransferDraft)
    case confirmation(TransferDraft, TransferReceipt)
}

/// Builds destinations and passes the screen-owned model between steps.
@MainActor
final class TransferCoordinator: TransferDetailsCoordinator,
    TransferReviewCoordinator, TransferConfirmationCoordinator {
    let navigationRouter = NavigationRouter<TransferRoute>(root: .details)

    func reviewTransfer(_ draft: TransferDraft) {
        guard navigationRouter.path.isEmpty else {
            return
        }
        navigationRouter.push(.review(draft))
    }

    func editTransfer() {
        navigationRouter.popToRoot()
    }

    func showConfirmation(_ draft: TransferDraft, receipt: TransferReceipt) {
        // Keep the confirmation transition to one push. Its back button is hidden.
        navigationRouter.push(.confirmation(draft, receipt))
    }

    func returnToDetails() {
        navigationRouter.popToRoot()
    }

    @ViewBuilder
    func makeView(for route: TransferRoute) -> some View {
        switch route {
        case .details:
            TransferDetailsView(viewModel: TransferDetailsViewModel(coordinator: self))
        case .review(let draft):
            TransferReviewView(viewModel: TransferReviewViewModel(draft: draft, coordinator: self))
        case .confirmation(let draft, let receipt):
            TransferConfirmationView(
                viewModel: TransferConfirmationViewModel(
                    draft: draft,
                    receipt: receipt,
                    coordinator: self
                )
            )
        }
    }
}
