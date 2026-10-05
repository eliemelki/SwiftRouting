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
    func signIn() { signInCount += 1 }
}

@MainActor
private final class ProfileCoordinatorSpy: ProfileViewCoordinator {
    private(set) var openedInfo: ProfileInfoRoute?
    private(set) var didShowDetails = false
    private(set) var didSignOut = false

    func showPersonalDetails() { didShowDetails = true }
    func showInfo(_ info: ProfileInfoRoute) { openedInfo = info }
    func signOut() { didSignOut = true }
}

@MainActor
@Test func testScreenModelsWorkWithCoordinatorProtocolsOnly() {
    let login = LoginCoordinatorSpy()
    LoginViewModel(coordinator: login).signIn()
    #expect(login.signInCount == 1)

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
@Test func testRootModelRelaysCoordinatorStateAndReleasesSubscription() {
    let coordinator = BankAppCoordinator()
    var model: BankAppViewModel? = BankAppViewModel(coordinator: coordinator)
    weak var weakModel = model
    #expect(model?.route == .login)
    coordinator.signIn()
    #expect(model?.route == .signedIn)
    coordinator.signOut()
    #expect(model?.route == .login)
    model = nil
    #expect(weakModel == nil)
    coordinator.signIn()
}
