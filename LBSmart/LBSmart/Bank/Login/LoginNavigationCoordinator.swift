import SwiftRouting
import SwiftUI

enum LoginRoute: Route {
    case login
    case contactUs
}

@MainActor
final class LoginNavigationCoordinator: LoginCoordinator, ContactUsCoordinator {
    let navigationRouter = NavigationRouter<LoginRoute>(root: .login)
    private weak var appCoordinator: BankAppCoordinator?

    init(appCoordinator: BankAppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func signIn() {
        appCoordinator?.signIn()
    }

    func showContactUs() {
        guard navigationRouter.path.isEmpty else {
            return
        }
        navigationRouter.push(.contactUs)
    }

    func closeContactUs() {
        navigationRouter.popLast()
    }

    @ViewBuilder
    func makeView(for route: LoginRoute) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: LoginViewModel(coordinator: self))
        case .contactUs:
            ContactUsView(viewModel: ContactUsViewModel(coordinator: self))
        }
    }
}
