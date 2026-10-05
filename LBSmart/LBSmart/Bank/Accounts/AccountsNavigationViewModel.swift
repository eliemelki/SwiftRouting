//
//  AccountsNavigationViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class AccountsNavigationViewModel: ObservableObject {
    let coordinator: AccountsCoordinator

    init(coordinator: AccountsCoordinator) {
        self.coordinator = coordinator
    }
}
