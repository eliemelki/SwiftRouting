import SwiftUI

struct TransferDetailsView: View {
    @StateObject private var viewModel: TransferDetailsViewModel

    init(viewModel: TransferDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("Step 1 of 3 · Transfer details") {
                Picker(
                    "From",
                    selection: Binding(
                        get: {
                            viewModel.draft.sourceAccount
                        },
                        set: {
                            viewModel.selectAccount($0)
                        }
                    )
                ) {
                    ForEach(viewModel.accounts) { account in
                        Text(account.name).tag(account)
                    }
                }
                LabeledContent("Available", value: viewModel.draft.sourceAccount.balance.formatted(.currency(code: "NZD")))
                TextField(
                    "Recipient name",
                    text: Binding(
                        get: {
                            viewModel.draft.recipient
                        },
                        set: {
                            viewModel.setRecipient($0)
                        }
                    )
                )
                TextField(
                    "Amount (NZD)",
                    text: Binding(
                        get: {
                            viewModel.draft.amountText
                        },
                        set: {
                            viewModel.setAmount($0)
                        }
                    )
                )
                .keyboardType(.decimalPad)
                TextField(
                    "Reference (optional)",
                    text: Binding(
                        get: {
                            viewModel.draft.reference
                        },
                        set: {
                            viewModel.setReference($0)
                        }
                    )
                )
            }
            Section {
                if let message = viewModel.validationMessage {
                    Text(message).font(.footnote).foregroundStyle(.secondary)
                }
                Button("Review transfer", action: viewModel.review)
                    .disabled(!viewModel.canReview)
            } footer: {
                Text("Demo only. No money will be moved.")
            }
        }
        .navigationTitle("Transfer")

    }
}
