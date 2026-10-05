import SwiftUI

struct TransferConfirmationView: View {
    @StateObject private var viewModel: TransferConfirmationViewModel

    init(viewModel: TransferConfirmationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section("Step 3 of 3 · Complete") {
                Label("Demo transfer complete", systemImage: "checkmark.circle.fill")
                    .font(.headline).foregroundStyle(.green)
                LabeledContent("From", value: viewModel.receipt.sourceAccount.name)
                LabeledContent("To", value: viewModel.receipt.recipient)
                LabeledContent("Amount", value: viewModel.receipt.amount.formatted(.currency(code: "NZD")))
                LabeledContent("Reference", value: viewModel.receipt.reference.isEmpty ? "None" : viewModel.receipt.reference)
                Text("Receipt: \(viewModel.receipt.id.uuidString)").font(.caption).foregroundStyle(.secondary)
            }
            Section {
                Button("Start another transfer", action: viewModel.startNewTransfer)
            } footer: {
                Text("No money was moved. Account balances are unchanged in this demo.")
            }
        }
        .navigationTitle("Confirmation")
        .navigationBarBackButtonHidden()
    }
}
