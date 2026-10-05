//
//  CardsNavigationCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

enum CardsRoute: Route {
    case cards
    case accountDetail(BankAccount)
}

@MainActor
final class CardsNavigationCoordinator: AccountDetailCoordinator {
    let navigationRouter = NavigationRouter<CardsRoute>(root: .cards)
    private(set) lazy var pagingCoordinator = CardsCoordinator(navigationCoordinator: self)

    @discardableResult
    func showLinkedAccount(for card: BankCard) -> RouteEntry<CardsRoute> {
        navigationRouter.push(.accountDetail(card.account))
    }

    func closeAccountDetail() {
        navigationRouter.popLast()
    }

    @ViewBuilder
    func makeView(for route: CardsRoute) -> some View {
        switch route {
        case .cards:
            CardsView(viewModel: CardsViewModel(coordinator: pagingCoordinator))
        case .accountDetail(let account):
            AccountDetailView(viewModel: AccountDetailViewModel(account: account, coordinator: self))
        }
    }
}
