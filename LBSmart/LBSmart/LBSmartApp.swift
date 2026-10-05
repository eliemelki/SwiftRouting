//
//  LBSmartApp.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@main
struct LBSmartApp: App {
    var body: some Scene {
        WindowGroup {
            BankAppView(viewModel: BankAppViewModel(coordinator: BankAppCoordinator()))
        }
    }
}
