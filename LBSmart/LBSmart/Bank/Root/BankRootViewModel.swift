//
//  BankRootViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class BankRootViewModel: ObservableObject {
    @Published private(set) var route: BankAppRoute = .login
    let coordinator: BankAppCoordinator

    init(coordinator: BankAppCoordinator? = nil) {
        let coordinator = coordinator ?? BankAppCoordinator()
        self.coordinator = coordinator
        coordinator.$route.assign(to: &$route)
    }
}
