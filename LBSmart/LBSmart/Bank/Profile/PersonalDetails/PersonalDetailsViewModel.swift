//
//  PersonalDetailsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class PersonalDetailsViewModel: ObservableObject {
    let name = "Alex Morgan"
    let email = "alex@example.com"
    private let coordinator: any PersonalDetailsCoordinator

    init(coordinator: any PersonalDetailsCoordinator) { self.coordinator = coordinator }
    func close() { coordinator.closePersonalDetails() }
}
