//
//  BankAppViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class BankAppViewModel: ObservableObject {
    let coordinator: BankAppCoordinator

    init(coordinator: BankAppCoordinator) {
        self.coordinator = coordinator
    }
}
