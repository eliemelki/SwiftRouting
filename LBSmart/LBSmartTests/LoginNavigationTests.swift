import Testing

@testable import LBSmart

@MainActor
@Test func testLoginCanOpenContactUsWithoutSigningIn() {
    let app = BankAppCoordinator()
    let login = app.loginCoordinator
    #expect(login.navigationRouter.root == .login)
    #expect(login.navigationRouter.path.isEmpty)
    let model = LoginViewModel(coordinator: login)
    model.showContactUs()
    model.showContactUs()
    #expect(login.navigationRouter.path.map(\.route) == [.contactUs])
    #expect(app.stateRouter.route == .login)
    #expect(app.tabCoordinator == nil)
    ContactUsViewModel(coordinator: login).close()
    #expect(login.navigationRouter.path.isEmpty)
    model.showContactUs()
    login.navigationRouter.popLast(animated: false)
    #expect(login.navigationRouter.path.isEmpty)
}

@MainActor
@Test func testLoginNavigationResetsAcrossSignInAndLogout() {
    let app = BankAppCoordinator()
    let login = app.loginCoordinator
    let model = LoginViewModel(coordinator: login)
    model.showContactUs()
    ContactUsViewModel(coordinator: login).close()
    model.signIn()
    #expect(app.stateRouter.route == .signedIn)
    #expect(app.tabCoordinator != nil)
    #expect(login.navigationRouter.path.isEmpty)
    app.signOut()
    #expect(app.stateRouter.route == .login)
    #expect(login.navigationRouter.root == .login)
    #expect(login.navigationRouter.path.isEmpty)
    model.showContactUs()
    // Root/session transitions also clear an outstanding login destination.
    app.signIn()
    #expect(login.navigationRouter.path.isEmpty)
    app.signOut()
    #expect(login.navigationRouter.path.isEmpty)
}

@MainActor
@Test func testLoginCoordinatorDoesNotRetainApp() throws {
    var app: BankAppCoordinator? = BankAppCoordinator()
    weak var weakApp = app
    let login = try #require(app?.loginCoordinator)
    app = nil
    #expect(weakApp == nil)
    login.signIn()
    #expect(login.navigationRouter.path.isEmpty)
}
