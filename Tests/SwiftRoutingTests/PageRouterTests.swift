//
//  PageRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import Combine
import Testing

@testable import SwiftRouting

@MainActor
@Test func testPageRouterSelection() {
    let router = PageRouter<TestRoute>(pages: [.first, .second])
    #expect(router.selection == router.pages[0])
    router.select(.second, animated: false)
    #expect(router.selection == router.pages[1])
    router.select(index: 0)
    #expect(router.selection == router.pages[0])
    router.select(index: -1)
    router.select(index: 2)
    router.select(RouteEntry(TestRoute.second))
    #expect(router.selection == router.pages[0])
}

@MainActor
@Test func testPageRouterInitialSelectionAndEmptyRoutes() {
    let selected = PageRouter<TestRoute>(pages: [.first, .second], selected: .second)
    #expect(selected.selection?.route == .second)
    let fallback = PageRouter<TestRoute>(pages: [.first], selected: .second)
    #expect(fallback.selection?.route == .first)
    fallback.select(.second)
    #expect(fallback.selection?.route == .first)
    let empty = PageRouter<TestRoute>(pages: [])
    empty.select(.first)
    empty.select(index: 0)
    #expect(empty.selection == nil)
}

@MainActor
@Test func testPageRouterRepeatedRoutes() {
    let router = PageRouter<TestRoute>(pages: [.first, .first])
    let entries = router.pages
    #expect(entries[0].id != entries[1].id)
    router.select(entries[1])
    #expect(router.selection == entries[1])
    router.select(.first)
    #expect(router.selection == entries[0])
    #expect(router.pages == entries)
}

@MainActor
@Test func testPageRouterStepsStopAtBoundaries() {
    let router = PageRouter<TestRoute>(pages: [.first, .second, .first])
    router.previous()
    #expect(router.selection == router.pages[0])
    router.next(animated: false)
    #expect(router.selection == router.pages[1])
    router.next()
    router.next()
    #expect(router.selection == router.pages[2])
    router.previous()
    #expect(router.selection == router.pages[1])
    let empty = PageRouter<TestRoute>(pages: [])
    empty.next()
    empty.previous()
    #expect(empty.selection == nil)
}

@MainActor
@Test func testPageSelectionActionsPublishOnlyValidChanges() {
    let router = PageRouter<TestRoute>(pages: [.first, .second])
    let other = PageRouter<TestRoute>(pages: [.first, .second])
    var selections: [RouteEntry<TestRoute>?] = []
    let subscription = router.$selection.sink {
        selections.append($0)
    }
    router.select(router.pages[0], animated: false)
    router.select(other.pages[1])
    router.select(index: Int.min)
    router.select(index: Int.max)
    #expect(selections == [router.pages[0]])
    router.select(router.pages[1], animated: false)
    router.select(.second)
    #expect(selections == [router.pages[0], router.pages[1]])
    subscription.cancel()
}

@MainActor
@Test func testPageEmptySelectionRejectsForeignEntry() {
    let router = PageRouter<TestRoute>(pages: [], selected: .second)
    router.select(RouteEntry(TestRoute.second))
    router.select(RouteEntry(TestRoute.first))
    #expect(router.selection == nil)
    #expect(router.pages.isEmpty)
}
