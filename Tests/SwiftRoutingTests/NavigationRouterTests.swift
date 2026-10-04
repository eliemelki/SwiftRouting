//
//  NavigationRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//
@testable import SwiftRouting
import Testing

@MainActor
@Test func testNavigationRouter() async throws {
    let router = NavigationRouter(root: firstRoute)
    #expect(router.root == firstRoute)
    #expect(router.path.count == 0)

    router.setRoot(firstRoute)
    #expect(router.root == firstRoute)
    #expect(router.path.count == 0)


    router.push(firstRoute)
    #expect(router.root == firstRoute)
    #expect(router.path.count == 1)
    #expect(router.path[0].route == firstRoute)

    router.popLast()
    router.popLast()
    #expect(router.path.count == 0)

    router.push(firstRoute, animated: false)
    router.push(firstRoute)
    router.push(firstRoute)
    #expect(router.path.count == 3)

    router.popLast(animated: false)
    #expect(router.path.count == 2)

    router.popToRoot()
    router.popToRoot(animated: false)
    #expect(router.path.count == 0)
}
