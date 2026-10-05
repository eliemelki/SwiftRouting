//
//  CardsCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

enum CardsRoute: Route { case cards, accountDetail(BankAccount) }

@MainActor
final class CardsNavigationCoordinator: ObservableObject, CardCoordinator, CardsPagingCoordinator, AccountDetailCoordinator {
    let navigationRouter = NavigationRouter<CardsRoute>(root: .cards)
    let pageRouter = PageRouter<BankCard>(pages: BankCard.samples)

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
            CardsView(viewModel: CardsViewModel(coordinator: self))
        case .accountDetail(let account):
            AccountDetailView(viewModel: AccountDetailViewModel(account: account, coordinator: self))
        }
    }

    func makeCardView(for card: BankCard) -> CardView {
        CardView(viewModel: CardViewModel(card: card, coordinator: self))
    }
}
