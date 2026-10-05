//
//  BankAppView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct BankAppView: View {
    @StateObject private var viewModel: BankAppViewModel

    init(viewModel: BankAppViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        // Switch the app root; each signed-in tab owns its own NavigationStack.
        viewModel.coordinator.makeView(for: viewModel.route)
            .tint(.teal)
    }
}
