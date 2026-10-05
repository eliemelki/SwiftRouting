//
//  StateRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import Combine
import Testing
@testable import SwiftRouting

@MainActor
@Test func testStateRouterPublishesReplacementsAndIgnoresCurrentRoute() {
    let router = StateRouter<TestRoute>(route: .first)
    var routes: [TestRoute] = []
    let subscription = router.$route.sink { routes.append($0) }
    #expect(router.route == .first)
    router.set(.second, animated: false)
    router.set(.second)
    router.set(.first)
    #expect(router.route == .first)
    #expect(routes == [.first, .second, .first])
    subscription.cancel()
}
