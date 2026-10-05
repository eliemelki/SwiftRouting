//
//  CardsViewCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

/// Owns card paging and builds each card's content.
@MainActor
final class CardsViewCoordinator {
    let pageRouter = PageRouter<BankCard>(pages: BankCard.samples)
    private weak var navigationCoordinator: CardsNavigationCoordinator?

    init(navigationCoordinator: CardsNavigationCoordinator) {
        self.navigationCoordinator = navigationCoordinator
    }

    /// Creates a card whose actions open details in the Cards navigation stack.
    @ViewBuilder
    func makeCardView(for card: BankCard) -> some View {
        if let navigationCoordinator {
            CardView(viewModel: CardViewModel(card: card, coordinator: navigationCoordinator))
        }
    }
}
