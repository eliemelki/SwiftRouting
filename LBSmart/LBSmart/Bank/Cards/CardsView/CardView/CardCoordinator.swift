//
//  CardCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting

/// The coordinator capabilities required by this screen.
@MainActor
protocol CardCoordinator: AnyObject {
    func showLinkedAccount(for card: BankCard)
}
