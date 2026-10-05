//
//  BankRootView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct BankRootView: View {
    @StateObject private var viewModel: BankRootViewModel

    init(viewModel: BankRootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        // Switch the app root; each signed-in tab owns its own NavigationStack.
        viewModel.coordinator.makeView(for: viewModel.route)
            .tint(.teal)
    }
}
