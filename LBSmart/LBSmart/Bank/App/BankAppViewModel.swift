//
//  BankAppViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class BankAppViewModel: ObservableObject {
    @Published private(set) var route: BankAppRoute = .login
    let coordinator: BankAppCoordinator

    init(coordinator: BankAppCoordinator) {
        self.coordinator = coordinator
        // The view observes this model; relay coordinator state without exposing its storage.
        coordinator.routePublisher.assign(to: &$route)
    }
}
