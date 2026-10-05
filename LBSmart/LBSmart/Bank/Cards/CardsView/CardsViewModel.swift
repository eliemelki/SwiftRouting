//
//  CardsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class CardsViewModel<C: CardsPagingCoordinator>: ObservableObject {
    let coordinator: C

    init(coordinator: C) {
        self.coordinator = coordinator
    }
}
