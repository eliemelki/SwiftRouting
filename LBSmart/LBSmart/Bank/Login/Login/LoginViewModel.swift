//
//  LoginViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    private let coordinator: any LoginCoordinator

    init(coordinator: any LoginCoordinator) {
        self.coordinator = coordinator
    }

    func showContactUs() {
        coordinator.showContactUs()
    }

    func signIn() {
        coordinator.signIn()
    }
}
