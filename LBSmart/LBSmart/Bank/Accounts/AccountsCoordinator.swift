//
//  AccountsCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

enum AccountsRoute: Route { case accounts, detail(BankAccount) }

/// Allows the same account detail screen to be pushed from either tab.
@MainActor
protocol AccountDetailCoordinating: AnyObject {
    func closeAccountDetail()
}

@MainActor
final class AccountsCoordinator: ObservableObject, AccountDetailCoordinating {
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
