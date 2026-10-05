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
    private(set) var session: BankSessionCoordinator?

    func signIn() {
        guard session == nil else { return }
        session = BankSessionCoordinator(appCoordinator: self)
        route = .signedIn
    }

    func signOut() {
        route = .login
        session = nil
    }

    @ViewBuilder
    func makeView(for route: BankAppRoute) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: LoginViewModel(coordinator: self))
        case .signedIn:
            if let session {
                BankTabsView(viewModel: BankTabsViewModel(coordinator: session))
            }
        }
    }
}
