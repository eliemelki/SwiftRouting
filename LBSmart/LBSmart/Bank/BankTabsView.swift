//
//  BankTabsView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct BankTabsView: View {
    @StateObject private var viewModel: BankTabsViewModel

    init(viewModel: BankTabsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.tabRouter.view { tab in
            viewModel.coordinator.makeView(for: tab)
        } makeLabel: { tab in
            switch tab {
            case .accounts: Label("Accounts", systemImage: "building.columns")
            case .cards: Label("Cards", systemImage: "creditcard")
            case .profile: Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}
