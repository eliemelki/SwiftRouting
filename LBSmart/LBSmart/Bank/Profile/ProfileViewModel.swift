//
//  ProfileViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    let displayName = "Alex Morgan"
    let infoLinks = ProfileInfo.allCases
    private let coordinator: ProfileCoordinator

    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }

    func showPersonalDetails() { coordinator.showPersonalDetails() }
    func showInfo(_ info: ProfileInfo) { coordinator.showInfo(info) }
    func signOut() { coordinator.signOut() }
}
