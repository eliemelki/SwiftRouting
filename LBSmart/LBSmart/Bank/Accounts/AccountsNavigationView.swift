//
//  AccountsNavigationView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

struct AccountsNavigationView: View {
    @StateObject private var viewModel: AccountsNavigationViewModel

    init(viewModel: AccountsNavigationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
    }
}
