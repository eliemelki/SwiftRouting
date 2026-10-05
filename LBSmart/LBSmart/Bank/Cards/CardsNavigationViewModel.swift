//
//  CardsNavigationViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class CardsNavigationViewModel: ObservableObject {
    let coordinator: CardsCoordinator

    init(coordinator: CardsCoordinator) {
        self.coordinator = coordinator
    }
}
