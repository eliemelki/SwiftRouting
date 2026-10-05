//
//  TabRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import Combine
import Testing

@testable import SwiftRouting

@MainActor
@Test func testTabRouterSelection() {
    let router = TabRouter<TestRoute>(tabs: [.first, .second])
    #expect(router.selection == router.tabs[0])
    router.select(.second, animated: false)
    #expect(router.selection == router.tabs[1])
    router.select(index: 0)
    #expect(router.selection == router.tabs[0])
    router.select(index: -1)
    router.select(index: 2)
    router.select(RouteEntry(TestRoute.second))
    #expect(router.selection == router.tabs[0])
}

@MainActor
@Test func testTabRouterInitialSelectionAndEmptyRoutes() {
    let selected = TabRouter<TestRoute>(tabs: [.first, .second], selected: .second)
    #expect(selected.selection?.route == .second)
    let fallback = TabRouter<TestRoute>(tabs: [.first], selected: .second)
    #expect(fallback.selection?.route == .first)
    fallback.select(.second)
    #expect(fallback.selection?.route == .first)
    let empty = TabRouter<TestRoute>(tabs: [])
    empty.select(.first)
    empty.select(index: 0)
    #expect(empty.selection == nil)
}

@MainActor
@Test func testTabRouterRepeatedRoutes() {
    let router = TabRouter<TestRoute>(tabs: [.first, .first])
    let entries = router.tabs
    #expect(entries[0].id != entries[1].id)
    router.select(entries[1])
    #expect(router.selection == entries[1])
    router.select(.first)
    #expect(router.selection == entries[0])
    #expect(router.tabs == entries)
}

@MainActor
@Test func testTabSelectionActionsPublishOnlyValidChanges() {
    let router = TabRouter<TestRoute>(tabs: [.first, .second])
    let other = TabRouter<TestRoute>(tabs: [.first, .second])
    var selections: [RouteEntry<TestRoute>?] = []
    let subscription = router.$selection.sink {
        selections.append($0)
    }
    router.select(router.tabs[0], animated: false)
    router.select(other.tabs[1])
    router.select(index: Int.min)
    router.select(index: Int.max)
    #expect(selections == [router.tabs[0]])
    router.select(router.tabs[1], animated: false)
    router.select(.second)
    #expect(selections == [router.tabs[0], router.tabs[1]])
    subscription.cancel()
}

@MainActor
@Test func testTabEmptySelectionRejectsForeignEntry() {
    let router = TabRouter<TestRoute>(tabs: [], selected: .second)
    router.select(RouteEntry(TestRoute.second))
    router.select(RouteEntry(TestRoute.first))
    #expect(router.selection == nil)
    #expect(router.tabs.isEmpty)
}
