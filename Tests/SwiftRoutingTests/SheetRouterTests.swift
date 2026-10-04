//
//  SheetRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

import Foundation
import Testing
import SwiftUI
@testable import SwiftRouting

@MainActor
@Test func testSheetRouterInitialState() async throws {
    let sheetRouter = MockSheetRouter()
    #expect(!sheetRouter.isPresentingSheet)
}

@MainActor
@Test func testSheetRouterFullShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(firstRoute, sheetType: .fullScreen)
    sheetRouter.expectFull(firstRoute)
}

@MainActor
@Test func testSheetRouterPartialShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(firstRoute)
    sheetRouter.expectPartial(firstRoute)
}



@MainActor
@Test func testSheetRouterMultipleShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(firstRoute)
    await sheetRouter.show(firstRoute, sheetType: .fullScreen)
    sheetRouter.expectFull(firstRoute)
}

@MainActor
@Test func testSheetDismissHandler() async throws {
    var firstDismissCalled = false
    var secondDismissCalled = false
    var thirdDismissCalled = false

    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(firstRoute) {
        firstDismissCalled = !firstDismissCalled
    }
    await sheetRouter.show(firstRoute, sheetType: .fullScreen) {
        secondDismissCalled = !secondDismissCalled
    }
    #expect(firstDismissCalled)
    #expect(!secondDismissCalled)
    #expect(!thirdDismissCalled)


    await sheetRouter.show(firstRoute, sheetType: .fullScreen) {
        thirdDismissCalled = !thirdDismissCalled
    }

    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(!thirdDismissCalled)

    await sheetRouter.hide()
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(thirdDismissCalled)
    #expect(sheetRouter.presentedSheetType == nil)
    #expect(!sheetRouter.isPresentingSheet)
}

@MainActor
@Test func testSheetConcurrent() async throws {
    var dismissTrack: [Int] = []


    let sheetRouter = MockSheetRouter()
    let task1 = Task {
        await sheetRouter.show(firstRoute) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetRouter.show(firstRoute, sheetType: .fullScreen) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await sheetRouter.show(secondRoute, sheetType: .fullScreen) {
            dismissTrack.append(3)
        }
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3 = await task3.value
    let _ = await "\(t1) \(t2) \(t3)"
    #expect(dismissTrack == [1,2])
    #expect(sheetRouter.fullScreenEntry?.route == secondRoute)

    let task4 = Task {
        await sheetRouter.hide()
        return 4
    }


    async let t4 = await task4.value

    let _ = await "\(t4)"

    #expect(dismissTrack == [1,2,3])
}


extension MockSheetRouter {

    func expectFull(_ route: TestRoute) {
        let fullScreenEntry = self.fullScreenEntry
        #expect(fullScreenEntry != nil)
        #expect(route == fullScreenEntry?.route)
        #expect(self.presentedSheetType == .fullScreen)

        let partialEntry = self.partialEntry
        #expect(partialEntry == nil)
        #expect(self.isPresentingSheet)
    }

    func expectPartial(_ route: TestRoute) {
        let partialEntry = self.partialEntry
        #expect(partialEntry != nil)
        #expect(route == partialEntry?.route)

        let fullScreenEntry = self.fullScreenEntry
        #expect(fullScreenEntry == nil)
        #expect(self.isPresentingSheet)
    }
}

@MainActor
@Test func testRepeatedSheetRouteHasDistinctEntries() async {
    let router = MockSheetRouter()
    let first = await router.show(.first)
    let second = await router.show(.first)
    #expect(first.route == second.route)
    #expect(first.id != second.id)
    #expect(!router.isDisplaying(first))
    #expect(router.isDisplaying(second))
    await router.hide()
}

@MainActor
@Test func testDismissCallbackIsConsumedOnce() async {
    let router = SheetRouter<TestRoute>()
    var dismissCount = 0
    await router.show(.first) { dismissCount += 1 }
    router.partialEntry = nil // SwiftUI clears the item binding on a swipe.
    router.didDismissFullScreen() // An unrelated callback must not clear the handler.
    #expect(dismissCount == 0)
    router.didDismissPartialSheet()
    router.didDismissPartialSheet()
    #expect(dismissCount == 1)
}

@MainActor
@Test func testReplacementWaitsForInteractiveDismissal() async {
    let router = SheetRouter<TestRoute>()
    var dismissCount = 0
    await router.show(.first) { dismissCount += 1 }
    router.partialEntry = nil
    let replacement = Task { await router.show(.second, sheetType: .fullScreen) }
    // Let the queued replacement reach the dismissal continuation.
    for _ in 0..<10 { await Task.yield() }
    #expect(router.fullScreenEntry == nil)
    router.didDismissPartialSheet()
    let entry = await replacement.value
    #expect(router.fullScreenEntry == entry)
    #expect(dismissCount == 1)
}
