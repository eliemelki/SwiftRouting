//
//  AccountsViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class AccountsViewModel: ObservableObject {
    let accounts = BankAccount.samples
    private let coordinator: any AccountsViewCoordinator
    var totalBalance: Double {
        accounts.reduce(0) {
            $0 + $1.balance
        }
    }

    init(coordinator: any AccountsViewCoordinator) {
        self.coordinator = coordinator
    }

    func showAccount(_ account: BankAccount) {
        coordinator.showAccount(account)
    }
}
