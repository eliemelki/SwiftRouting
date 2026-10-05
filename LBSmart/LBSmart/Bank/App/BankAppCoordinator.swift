//
//  BankAppCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

enum BankAppRoute: Route {
    case login
    case signedIn
}

/// Owns the login flow and the lifetime of a signed-in session.
@MainActor
final class BankAppCoordinator {
    let stateRouter = StateRouter<BankAppRoute>(route: .login)
    private(set) lazy var loginCoordinator = LoginNavigationCoordinator(appCoordinator: self)
    private(set) var tabCoordinator: BankTabsCoordinator?

    func signIn() {
        guard tabCoordinator == nil else {
            return
        }
        loginCoordinator.navigationRouter.popToRoot(animated: false)
        tabCoordinator = BankTabsCoordinator(appCoordinator: self)
        stateRouter.set(.signedIn)
    }

    func signOut() {
        loginCoordinator.navigationRouter.popToRoot(animated: false)
        stateRouter.set(.login)
        tabCoordinator = nil
    }

    @ViewBuilder
    func makeView(for route: BankAppRoute) -> some View {
        switch route {
        case .login:
            LoginNavigationView(viewModel: LoginNavigationViewModel(coordinator: loginCoordinator))
        case .signedIn:
            if let tabCoordinator {
                BankTabsView(viewModel: BankTabsViewModel(coordinator: tabCoordinator))
            }
        }
    }
}
