//
//  AccountsNavigationViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class AccountsNavigationViewModel<C: AccountsNavigationCoordinator>: ObservableObject {
    let coordinator: C

    init(coordinator: C) {
        self.coordinator = coordinator
    }
}
