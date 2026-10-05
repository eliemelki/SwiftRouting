//
//  BankTabsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class BankTabsViewModel: ObservableObject {
    let coordinator: BankSessionCoordinator

    init(coordinator: BankSessionCoordinator) {
        self.coordinator = coordinator
    }
}
