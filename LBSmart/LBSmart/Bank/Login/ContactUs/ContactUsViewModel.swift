import SwiftUI

@MainActor
final class ContactUsViewModel: ObservableObject {
    let supportEmail = "support@lbsmart.example"
    let message = "Need help signing in or have a question about your accounts? Our support team is here to help."
    let demoNotice = "LB SMART is a demo. This is a sample email address and no live support service is connected."
    private let coordinator: any ContactUsCoordinator

    init(coordinator: any ContactUsCoordinator) {
        self.coordinator = coordinator
    }

    func close() {
        coordinator.closeContactUs()
    }
}
