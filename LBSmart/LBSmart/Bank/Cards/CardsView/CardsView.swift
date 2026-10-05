//
//  CardsView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct CardsView: View {
    @StateObject private var viewModel: CardsViewModel

    init(viewModel: CardsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your cards").font(.title2.bold()).padding(.horizontal, 24)
            Text("Swipe to explore your cards and their linked accounts.")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
            viewModel.coordinator.pageRouter.view(indexDisplayMode: .always) { card in
                viewModel.coordinator.makeCardView(for: card)
            }
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            Spacer()
        }
        .padding(.top, 16)
        .navigationTitle("Cards")
    }
}
