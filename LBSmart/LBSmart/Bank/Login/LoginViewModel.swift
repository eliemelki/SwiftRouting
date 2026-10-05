//
//  LoginViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    private let coordinator: BankAppCoordinator

    init(coordinator: BankAppCoordinator) {
        self.coordinator = coordinator
    }

    func signIn() {
        coordinator.signIn()
    }
}
