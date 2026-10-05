//
//  CardView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct CardView: View {
    @StateObject private var viewModel: CardViewModel

    init(viewModel: CardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 26) {
                HStack {
                    Text("LB SMART").font(.headline)
                    Spacer()
                    Image(systemName: "wave.3.right").font(.title2)
                }
                Image(systemName: "simcard").font(.largeTitle)
                Text("••••  ••••  ••••  " + viewModel.card.lastFour)
                    .font(.title3.monospaced())
                HStack {
                    Text(viewModel.card.name)
                    Spacer()
                    Text("DEBIT").font(.caption.bold())
                }
            }
            .padding(24)
            .foregroundStyle(.white)
            .background(LinearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            Button(action: viewModel.showLinkedAccount) {
                Label("View linked account", systemImage: "building.columns")
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("bank.linkedAccount")
            Text(viewModel.card.account.name).font(.caption).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 36)
    }
}
