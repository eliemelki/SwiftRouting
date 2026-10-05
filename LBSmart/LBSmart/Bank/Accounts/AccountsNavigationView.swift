//
//  AccountsNavigationView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

struct AccountsNavigationView<C: AccountsNavigationCoordinator>: View {
    @StateObject private var viewModel: AccountsNavigationViewModel<C>

    init(viewModel: AccountsNavigationViewModel<C>) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
    }
}
