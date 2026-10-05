//
//  CoordinatorContractTests.swift
//  LBSmartTests
//
//  Created by Elie Melki on 05/10/2026.
//

import Testing

@testable import LBSmart

@MainActor
private final class LoginCoordinatorSpy: LoginCoordinator {
    private(set) var signInCount = 0
    private(set) var contactUsCount = 0

    func showContactUs() {
        contactUsCount += 1
    }
    func signIn() {
        signInCount += 1
    }
}

@MainActor
private final class ProfileCoordinatorSpy: ProfileViewCoordinator {
    private(set) var openedInfo: ProfileInfoRoute?
    private(set) var didShowDetails = false
    private(set) var didSignOut = false

    func showPersonalDetails() {
        didShowDetails = true
    }
    func showInfo(_ info: ProfileInfoRoute) {
        openedInfo = info
    }
    func signOut() {
        didSignOut = true
    }
}

@MainActor
@Test func testScreenModelsWorkWithCoordinatorProtocolsOnly() {
    let login = LoginCoordinatorSpy()
    LoginViewModel(coordinator: login).signIn()
    #expect(login.signInCount == 1)
    LoginViewModel(coordinator: login).showContactUs()
    #expect(login.contactUsCount == 1)

    let profile = ProfileCoordinatorSpy()
    let model = ProfileViewModel(coordinator: profile)
    model.showPersonalDetails()
    model.showInfo(.privacy)
    model.signOut()
    #expect(profile.didShowDetails)
    #expect(profile.openedInfo == .privacy)
    #expect(profile.didSignOut)
}

@MainActor
@Test func testRootModelUsesStateRouterAndIsReleased() {
    let coordinator = BankAppCoordinator()
    var model: BankAppViewModel? = BankAppViewModel(coordinator: coordinator)
    weak var weakModel = model
    #expect(model?.coordinator.stateRouter.route == .login)
    coordinator.signIn()
    #expect(model?.coordinator.stateRouter.route == .signedIn)
    coordinator.signOut()
    #expect(model?.coordinator.stateRouter.route == .login)
    model = nil
    #expect(weakModel == nil)
    coordinator.signIn()
}
