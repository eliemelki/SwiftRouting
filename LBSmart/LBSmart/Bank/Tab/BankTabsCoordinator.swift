//
//  BankTabCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

enum BankTab: Route {
    case accounts, cards, profile
}

/// Owns independent navigation coordinators for the signed-in tabs.
@MainActor
final class BankTabsCoordinator {
    let tabRouter = TabRouter<BankTab>(tabs: [.accounts, .cards, .profile])
    let accountsCoordinator = AccountsCoordinator()
    let cardsCoordinator = CardsNavigationCoordinator()
    private(set) lazy var profileCoordinator = ProfileCoordinator(sessionCoordinator: self)
    private weak var appCoordinator: BankAppCoordinator?

    init(appCoordinator: BankAppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func signOut() {
        appCoordinator?.signOut()
    }

    @ViewBuilder
    func makeView(for tab: BankTab) -> some View {
        switch tab {
        case .accounts:
            AccountsNavigationView(viewModel: AccountsNavigationViewModel(coordinator: accountsCoordinator))
        case .cards:
            CardsNavigationView(viewModel: CardsNavigationViewModel(coordinator: cardsCoordinator))
        case .profile:
            ProfileNavigationView(viewModel: ProfileNavigationViewModel(coordinator: profileCoordinator))
        }
    }
}
