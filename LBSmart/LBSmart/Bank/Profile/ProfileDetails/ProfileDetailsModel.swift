//
//  ProfileViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class ProfileDetailsViewModel: ObservableObject {
    let displayName = "Alex Morgan"
    let infoLinks = ProfileInfoRoute.allCases
    private let coordinator: ProfileDetailsCoordinator

    init(coordinator: ProfileDetailsCoordinator) {
        self.coordinator = coordinator
    }

    func showPersonalDetails() {
        coordinator.showPersonalDetails()
    }
    func showInfo(_ info: ProfileInfoRoute) {
        coordinator.showInfo(info)
    }
    func signOut() {
        coordinator.signOut()
    }
}
