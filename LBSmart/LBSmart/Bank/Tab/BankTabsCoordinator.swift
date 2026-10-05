//
//  BankTabCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

enum BankTabRoute: Route, CaseIterable {
    case accounts
    case cards
    case transfer
    case profile
}

/// Owns independent navigation coordinators for the signed-in tabs.
@MainActor
final class BankTabsCoordinator {
    let tabRouter = TabRouter<BankTabRoute>(tabs: BankTabRoute.allCases)
    
    let accountsCoordinator = AccountsCoordinator()
    let cardsCoordinator = CardsNavigationCoordinator()
    let transferCoordinator = TransferCoordinator()
    
    private(set) lazy var profileCoordinator = ProfileCoordinator(sessionCoordinator: self)
    private weak var appCoordinator: BankAppCoordinator?

    init(appCoordinator: BankAppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func signOut() {
        appCoordinator?.signOut()
    }

    @ViewBuilder
    func makeView(for tab: BankTabRoute) -> some View {
        switch tab {
        case .accounts:
            AccountsNavigationView(viewModel: AccountsNavigationViewModel(coordinator: accountsCoordinator))
        case .cards:
            CardsNavigationView(viewModel: CardsNavigationViewModel(coordinator: cardsCoordinator))
        case .transfer:
            TransferNavigationView(viewModel: TransferNavigationViewModel(coordinator: transferCoordinator))
        case .profile:
            ProfileNavigationView(viewModel: ProfileNavigationViewModel(coordinator: profileCoordinator))
        }
    }
}
