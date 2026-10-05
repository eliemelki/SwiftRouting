import Testing

//
//  NavigationRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//
@testable import SwiftRouting

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

@MainActor
@Test func testChangingRootPreservesEntryIdentities() {
    let router = NavigationRouter<TestRoute>(root: .first)
    let first = router.push(.first, animated: false)
    let second = router.push(.second, animated: false)
    router.setRoot(.second)
    #expect(router.root == .second)
    #expect(router.path == [first, second])
    router.popToRoot(animated: false)
    #expect(router.root == .second)
    #expect(router.path.isEmpty)
}

@MainActor
@Test func testNavigationRejectsEntriesFromAnotherRouter() {
    let router = NavigationRouter<TestRoute>(root: .first)
    let other = NavigationRouter<TestRoute>(root: .first)
    let local = router.push(.second, animated: false)
    let foreign = other.push(.second, animated: false)
    router.pop(entry: foreign, animated: false)
    router.pop(to: foreign, animated: false)
    #expect(router.path == [local])
    #expect(other.path == [foreign])
}

@Test func testRouteEntryCopyPreservesIdentityAndHashing() {
    let entry = RouteEntry(TestRoute.first)
    let copy = entry
    let repeated = RouteEntry(TestRoute.first)
    #expect(copy == entry)
    #expect(copy.id == entry.id)
    #expect(repeated != entry)
    #expect(Set([entry, copy, repeated]).count == 2)
}
