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
final class BankAppCoordinator: ObservableObject {
    @Published private(set) var route: BankAppRoute = .login
    private(set) var tabCoordinator: BankTabCoordinator?

    func signIn() {
        guard tabCoordinator == nil else { return }
        tabCoordinator = BankTabCoordinator(appCoordinator: self)
        route = .signedIn
    }

    func signOut() {
        route = .login
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
