import SwiftUI

@MainActor
final class TransferNavigationViewModel: ObservableObject {
    let coordinator: TransferCoordinator

    init(coordinator: TransferCoordinator) {
        self.coordinator = coordinator
    }
}
