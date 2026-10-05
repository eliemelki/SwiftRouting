//
//  InfoSheetViewModel.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

@MainActor
final class InfoSheetViewModel: ObservableObject {
    @Published private(set) var isExpanded = false
    let info: ProfileInfoRoute

    var usesDynamicHeight: Bool {
        info != .support
    }
    var additionalInformation: String {
        switch info {
        case .security:
            return
                "Review your devices regularly and lock your card if it is misplaced. Never share a one-time verification code with another person."
        case .privacy:
            return
                "Signing out clears the sample banking session. The next sign-in starts with fresh navigation and card selection. No account information is saved to disk."
        case .support: return "Contact your bank directly for help with a real account."
        }
    }
    private let coordinator: any InfoSheetCoordinator

    init(info: ProfileInfoRoute, coordinator: any InfoSheetCoordinator) {
        self.info = info
        self.coordinator = coordinator
    }

    func toggleDetails() {
        isExpanded.toggle()
    }

    func close() {
        coordinator.closeInfo()
    }
}
