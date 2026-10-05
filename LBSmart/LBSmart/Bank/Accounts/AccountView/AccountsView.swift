//
//  AccountsView.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

struct AccountsView: View {
    @StateObject private var viewModel: AccountsViewModel

    init(viewModel: AccountsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total balance").foregroundStyle(.secondary)
                    Text(viewModel.totalBalance, format: .currency(code: "NZD"))
                        .font(.largeTitle.bold())
                }
                .padding(.vertical, 12)
            }
            Section("Your accounts") {
                ForEach(viewModel.accounts) { account in
                    Button {
                        viewModel.showAccount(account)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(account.name).font(.headline)
                                Text(account.number).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(account.balance, format: .currency(code: "NZD"))
                            Image(systemName: "chevron.right").font(.caption)
                        }
                        .foregroundStyle(.primary)
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Accounts")
    }
}
