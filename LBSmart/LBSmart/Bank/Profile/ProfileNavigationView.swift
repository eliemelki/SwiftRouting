//
//  ProfileNavigationView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

struct ProfileNavigationView: View {
    @StateObject private var viewModel: ProfileNavigationViewModel

    init(viewModel: ProfileNavigationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
        .sheetRouterView(viewModel.coordinator.sheetRouter) { route in
            viewModel.coordinator.makeSheet(for: route)
        }
    }
}
