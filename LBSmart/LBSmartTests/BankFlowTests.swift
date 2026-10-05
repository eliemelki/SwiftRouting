//
//  BankFlowTests.swift
//  LBSmartTests
//
//  Created by Elie Melki on 05/10/2026.
//

import Testing
@testable import LBSmart

@MainActor
@Test func testBankLoginAndFreshSessionAfterLogout() throws {
    let app = BankAppCoordinator()
    let rootModel = BankRootViewModel(coordinator: app)
    #expect(rootModel.route == .login)
    #expect(app.session == nil)
    LoginViewModel(coordinator: app).signIn()
    let session = try #require(app.session)
    #expect(rootModel.route == .signedIn)
    session.cardsCoordinator.showLinkedAccount(for: BankCard.samples[0])
    session.tabRouter.select(.profile)
    ProfileViewModel(coordinator: session.profileCoordinator).signOut()
    #expect(rootModel.route == .login)
    #expect(app.session == nil)
    app.signIn()
    let fresh = try #require(app.session)
    #expect(fresh !== session)
    #expect(fresh.tabRouter.selection?.route == .accounts)
    #expect(fresh.cardsCoordinator.navigationRouter.path.isEmpty)
}

@MainActor
@Test func testCardsPushLinkedAccountWithoutChangingAccountsStack() throws {
    let app = BankAppCoordinator()
    app.signIn()
    let session = try #require(app.session)
    let card = BankCard.samples[1]
    CardViewModel(card: card, coordinator: session.cardsCoordinator).showLinkedAccount()
    #expect(session.cardsCoordinator.navigationRouter.path.last?.route == .accountDetail(card.account))
    #expect(session.accountsCoordinator.navigationRouter.path.isEmpty)
    AccountDetailViewModel(account: card.account, coordinator: session.cardsCoordinator).close()
    #expect(session.cardsCoordinator.navigationRouter.path.isEmpty)
    session.cardsCoordinator.pageRouter.next(animated: false)
    #expect(session.cardsCoordinator.pageRouter.selection?.route == card)
    session.tabRouter.select(.accounts)
    session.tabRouter.select(.cards)
    #expect(session.cardsCoordinator.pageRouter.selection?.route == card)
}

@MainActor
@Test func testAccountsAndProfileNavigateThroughViewModels() throws {
    let app = BankAppCoordinator()
    app.signIn()
    let session = try #require(app.session)
    let account = BankAccount.samples[0]
    AccountsViewModel(coordinator: session.accountsCoordinator).showAccount(account)
    #expect(session.accountsCoordinator.navigationRouter.path.last?.route == .detail(account))
    let profile = session.profileCoordinator
    ProfileViewModel(coordinator: profile).showPersonalDetails()
    #expect(profile.navigationRouter.path.last?.route == .personalDetails)
    PersonalDetailsViewModel(coordinator: profile).close()
    #expect(profile.navigationRouter.path.isEmpty)
    #expect(session.accountsCoordinator.navigationRouter.path.count == 1)
}

@MainActor
@Test func testSessionIsReleasedOnLogout() throws {
    let app = BankAppCoordinator()
    app.signIn()
    weak var session = app.session
    weak var profile = app.session?.profileCoordinator
    app.signOut()
    #expect(session == nil)
    #expect(profile == nil)
}

@MainActor
@Test func testProfileInfoUsesSheetRouter() async throws {
    let app = BankAppCoordinator()
    app.signIn()
    let profile = try #require(app.session?.profileCoordinator)
    let model = ProfileViewModel(coordinator: profile)
    model.showInfo(.security)
    // Drain the fire-and-forget action before inspecting its presentation entry.
    while !profile.sheetRouter.isPresentingSheet { await Task.yield() }
    #expect(profile.sheetRouter.partialEntry?.route == .security)
    #expect(profile.sheetRouter.fullScreenEntry == nil)
}

