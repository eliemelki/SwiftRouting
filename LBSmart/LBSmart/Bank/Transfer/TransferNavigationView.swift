import SwiftUI

struct TransferNavigationView: View {
    @StateObject private var viewModel: TransferNavigationViewModel

    init(viewModel: TransferNavigationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
    }
}
