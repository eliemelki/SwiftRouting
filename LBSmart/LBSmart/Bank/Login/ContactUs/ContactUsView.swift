import SwiftUI

struct ContactUsView: View {
    @StateObject private var viewModel: ContactUsViewModel

    init(viewModel: ContactUsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                Label("How can we help?", systemImage: "bubble.left.and.bubble.right.fill")
                    .font(.title2.bold()).foregroundStyle(.teal)
                Text(viewModel.message)
            }
            Section {
                Text(viewModel.supportEmail).textSelection(.enabled)
            } header: {
                Text("Email support")
            } footer: {
                Text(viewModel.demoNotice)
            }
            Section {
                Button("Back to sign in", action: viewModel.close)
            }
        }
        .navigationTitle("Contact us")
        .navigationBarTitleDisplayMode(.inline)
    }
}
