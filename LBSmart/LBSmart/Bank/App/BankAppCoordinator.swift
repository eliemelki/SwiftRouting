//
//  BankAppCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

enum BankAppRoute: Route { case login, signedIn }

/// Owns the login flow and the lifetime of a signed-in session.
@MainActor
final class BankAppCoordinator: LoginCoordinator {
    let stateRouter = StateRouter<BankAppRoute>(route: .login)
    private(set) var tabCoordinator: BankTabsCoordinator?

    func signIn() {
        guard tabCoordinator == nil else { return }
        tabCoordinator = BankTabsCoordinator(appCoordinator: self)
        stateRouter.set(.signedIn)
    }

    func signOut() {
        stateRouter.set(.login)
        tabCoordinator = nil
    }

    @ViewBuilder
    func makeView(for route: BankAppRoute) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: LoginViewModel(coordinator: self))
        case .signedIn:
            if let tabCoordinator {
                BankTabsView(viewModel: BankTabsViewModel(coordinator: tabCoordinator))
            }
        }
    }
}
