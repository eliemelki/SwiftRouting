//
//  AccountDetailViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class AccountDetailViewModel: ObservableObject {
    let account: BankAccount
    private let coordinator: any AccountDetailCoordinator

    init(account: BankAccount, coordinator: any AccountDetailCoordinator) {
        self.account = account
        self.coordinator = coordinator
    }

    func close() {
        coordinator.closeAccountDetail()
    }
}
