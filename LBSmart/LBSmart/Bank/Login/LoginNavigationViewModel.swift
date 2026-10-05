import SwiftUI

@MainActor
final class LoginNavigationViewModel: ObservableObject {
    let coordinator: LoginNavigationCoordinator

    init(coordinator: LoginNavigationCoordinator) {
        self.coordinator = coordinator
    }
}
