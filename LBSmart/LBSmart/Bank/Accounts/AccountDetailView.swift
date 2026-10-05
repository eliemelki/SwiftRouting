//
//  AccountDetailView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct AccountDetailView: View {
    @StateObject private var viewModel: AccountDetailViewModel

    init(viewModel: AccountDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section("Available balance") {
                Text(viewModel.account.balance, format: .currency(code: "NZD"))
                    .font(.largeTitle.bold())
                    .padding(.vertical, 12)
            }
            Section("Account information") {
                LabeledContent("Name", value: viewModel.account.name)
                LabeledContent("Number", value: viewModel.account.number)
                LabeledContent("Currency", value: "NZD")
            }
            Section {
                Button("Back", action: viewModel.close)
            }
        }
        .navigationTitle(viewModel.account.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
