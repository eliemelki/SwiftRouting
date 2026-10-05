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
        viewModel.coordinator.stateRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
            .tint(.teal)
    }
}
