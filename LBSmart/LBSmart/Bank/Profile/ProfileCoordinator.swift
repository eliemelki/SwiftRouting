//
//  ProfileCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

enum ProfileRoute: Route { case profile, personalDetails }

enum ProfileInfoRoute: String, Route, CaseIterable {
    case security, privacy, support

    var title: String { rawValue.capitalized }
    var message: String {
        switch self {
        case .security: return "Keep your banking secure with a strong passcode. LB SMART will never ask you to share your PIN."
        case .privacy: return "This demo uses sample data held in memory. It does not collect personal information."
        case .support: return "For this demo, explore accounts, swipe your cards, and open the linked account. No real banking services are connected."
        }
    }
}

@MainActor
final class ProfileCoordinator: ObservableObject {
    let navigationRouter = NavigationRouter<ProfileRoute>(root: .profile)
    let sheetRouter = SheetRouter<ProfileInfoRoute>()
    private weak var sessionCoordinator: BankSessionCoordinator?

    init(sessionCoordinator: BankSessionCoordinator) {
        self.sessionCoordinator = sessionCoordinator
    }

    func showPersonalDetails() {
        navigationRouter.push(.personalDetails)
    }

    func closePersonalDetails() {
        navigationRouter.popLast()
    }

    func showInfo(_ info: ProfileInfoRoute) {
        sheetRouter.show(info)
    }

    func closeInfo() {
        sheetRouter.hide()
    }

    func signOut() {
        sessionCoordinator?.signOut()
    }

    @ViewBuilder
    func makeView(for route: ProfileRoute) -> some View {
        switch route {
        case .profile:
            ProfileView(viewModel: ProfileViewModel(coordinator: self))
        case .personalDetails:
            PersonalDetailsView(viewModel: PersonalDetailsViewModel(coordinator: self))
        }
    }

    func makeSheet(for info: ProfileInfoRoute) -> InfoSheetView {
        InfoSheetView(viewModel: InfoSheetViewModel(info: info, coordinator: self))
    }
}
