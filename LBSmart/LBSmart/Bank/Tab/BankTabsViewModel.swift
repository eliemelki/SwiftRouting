//
//  BankTabsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class BankTabsViewModel: ObservableObject {
    let coordinator: BankTabsCoordinator

    init(coordinator: BankTabsCoordinator) {
        self.coordinator = coordinator
    }
}
