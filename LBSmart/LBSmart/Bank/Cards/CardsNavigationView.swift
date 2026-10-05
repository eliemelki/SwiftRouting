//
//  CardsNavigationView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftRouting
import SwiftUI

struct CardsNavigationView: View {
    @StateObject private var viewModel: CardsNavigationViewModel

    init(viewModel: CardsNavigationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
    }
}
