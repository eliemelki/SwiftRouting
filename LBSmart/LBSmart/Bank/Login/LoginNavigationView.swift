import SwiftUI

struct LoginNavigationView: View {
    @StateObject private var viewModel: LoginNavigationViewModel

    init(viewModel: LoginNavigationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.makeView(for: route)
        }
    }
}
