//
//  CardsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class CardsViewModel: ObservableObject {
    let coordinator: CardsCoordinator

    init(coordinator: CardsCoordinator) {
        self.coordinator = coordinator
    }
}
