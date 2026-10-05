//
//  CardsViewCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI


/// Owns card paging and builds each card's content.
@MainActor
final class CardsCoordinator: CardCoordinator {
    let pageRouter = PageRouter<BankCard>(pages: BankCard.samples)
    private weak var parentCoordinator: CardsNavigationCoordinator?
    
    init(navigationCoordinator: CardsNavigationCoordinator) {
        self.parentCoordinator = navigationCoordinator
    }
    
    func showLinkedAccount(for card: BankCard) {
        if let parentCoordinator {
            parentCoordinator.showLinkedAccount(for: card)
        }
    }
    /// Creates a card whose actions open details in the Cards navigation stack.
    @ViewBuilder
    func makeCardView(for card: BankCard) -> some View {
        CardView(viewModel: CardViewModel(card: card, coordinator: self))
    }
}
