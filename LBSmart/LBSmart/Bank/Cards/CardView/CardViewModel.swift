//
//  CardViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class CardViewModel: ObservableObject {
    let card: BankCard
    private let coordinator: CardsCoordinator

    init(card: BankCard, coordinator: CardsCoordinator) {
        self.card = card
        self.coordinator = coordinator
    }

    func showLinkedAccount() {
        coordinator.showLinkedAccount(for: card)
    }
}
