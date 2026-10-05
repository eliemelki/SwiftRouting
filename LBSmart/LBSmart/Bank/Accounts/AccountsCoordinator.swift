//
//  AccountsCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

enum AccountsRoute: Route {
    case accounts
    case detail(BankAccount)
}

@MainActor
final class AccountsCoordinator: AccountsViewCoordinator, AccountsNavigationCoordinator, AccountDetailCoordinator {
    let navigationRouter = NavigationRouter<AccountsRoute>(root: .accounts)

    @discardableResult
    func showAccount(_ account: BankAccount) -> RouteEntry<AccountsRoute> {
        navigationRouter.push(.detail(account))
    }

    func closeAccountDetail() {
        navigationRouter.popLast()
    }

    @ViewBuilder
    func makeView(for route: AccountsRoute) -> some View {
        switch route {
        case .accounts:
            AccountsView(viewModel: AccountsViewModel(coordinator: self))
        case .detail(let account):
            AccountDetailView(viewModel: AccountDetailViewModel(account: account, coordinator: self))
        }
    }
}
