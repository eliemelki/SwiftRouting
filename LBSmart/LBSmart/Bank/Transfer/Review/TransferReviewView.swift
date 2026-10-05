import SwiftUI

struct TransferReviewView: View {
    @StateObject private var viewModel: TransferReviewViewModel

    init(viewModel: TransferReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("Step 2 of 3 · Review") {
                LabeledContent("From", value: viewModel.draft.sourceAccount.name)
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
                Button("Back to details", action: viewModel.edit)
                Button("Confirm demo transfer", action: viewModel.confirm)
                    .disabled(!viewModel.canConfirm)
            } footer: {
                Text("Edits here also update Details when you go back. Confirming creates a demo receipt; no money will be moved.")
            }
        }
        .navigationTitle("Review transfer")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel", action: viewModel.cancel)
            }
        }
    }
}
