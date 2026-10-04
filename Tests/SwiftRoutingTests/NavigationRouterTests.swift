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

@MainActor
@Test func testNavigationPopToExactOccurrence() {
    let router = NavigationRouter<TestRoute>(root: .first)
    let first = router.push(.second)
    let repeated = router.push(.second, animated: false)
    router.push(.first)
    #expect(first.id != repeated.id)
    router.pop(to: repeated, animated: false)
    #expect(router.path == [first, repeated])
    router.pop(to: repeated)
    router.pop(to: RouteEntry(TestRoute.second))
    #expect(router.path == [first, repeated])
    router.pop(to: first)
    #expect(router.path == [first])
}

@MainActor
@Test func testNavigationPopRemovesExactOccurrenceAndAbove() {
    let router = NavigationRouter<TestRoute>(root: .first)
    let first = router.push(.second)
    let repeated = router.push(.second)
    router.push(.first)
    router.pop(entry: repeated, animated: false)
    #expect(router.path == [first])
    router.pop(entry: repeated)
    router.pop(entry: RouteEntry(TestRoute.second))
    #expect(router.path == [first])
    router.pop(entry: first)
    #expect(router.path.isEmpty)
    router.pop(to: first)
    router.pop(entry: first)
    #expect(router.path.isEmpty)
    #expect(router.root == .first)
}
