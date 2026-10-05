//
//  BankModels.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import Foundation

struct BankAccount: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let balance: Double
    let number: String

    static let samples = [
        BankAccount(
            id: "everyday",
            name: "Everyday",
            balance: 4280.50,
            number: "12-3456-0789012-00"
        ),
        BankAccount(
            id: "savings",
            name: "Savings",
            balance: 18450,
            number: "12-3456-0789012-01"
        ),
    ]
}

struct BankCard: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let lastFour: String
    let account: BankAccount

    static let samples = [
        BankCard(
            id: "debit",
            name: "Everyday debit",
            lastFour: "4821",
            account: BankAccount.samples[0]
        ),
        BankCard(
            id: "travel",
            name: "Travel debit",
            lastFour: "9074",
            account: BankAccount.samples[1]
        ),
    ]
}
