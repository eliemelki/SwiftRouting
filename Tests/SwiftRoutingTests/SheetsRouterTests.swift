//
//  SheetsRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

import Foundation
import Testing
import SwiftUI
@testable import SwiftRouting



@MainActor
@Test func testSheetsRouterInitialState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    #expect(sheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testSheetsRouterShowState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 1)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testSheetsRouterMultipleShowState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.count == 3)
}

@MainActor
@Test func testSheetsRouterHideAllState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hideAll()
    #expect(sheetsRouter.sheets.isEmpty)
}


@MainActor
@Test func testSheetsRouterHideAtSpecificEntryState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    let entry = await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hide(entry: entry!)
    #expect(sheetsRouter.sheets.count == 2)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.count == 1)
}

@MainActor
@Test func testSheetsRouterHideState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 1)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.isEmpty)
    await sheetsRouter.show(firstRoute)
    await sheetsRouter.show(firstRoute)
    #expect(sheetsRouter.sheets.count == 2)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.count == 1)

}


@MainActor
@Test func testsSheetDismissHandler() async throws {
    var firstDismissCalled = false
    var secondDismissCalled = false
    var thirdDismissCalled = false

    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())

    await sheetsRouter.show(firstRoute) {
        firstDismissCalled = !firstDismissCalled
    }
    await sheetsRouter.show(firstRoute, sheetType: .fullScreen) {
        secondDismissCalled = !secondDismissCalled
    }

    await sheetsRouter.show(firstRoute, sheetType: .fullScreen) {
        thirdDismissCalled = !thirdDismissCalled
    }

    await sheetsRouter.hide()

    #expect(!firstDismissCalled)
    #expect(!secondDismissCalled)
    #expect(thirdDismissCalled)

    await sheetsRouter.hideAll()
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(thirdDismissCalled)

    #expect(sheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testSheetsConcurrent() async throws {
    var dismissTrack: [Int] = []
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())

    let task1 = Task {
        await sheetsRouter.show(firstRoute) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetsRouter.replace(firstRoute) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await sheetsRouter.hide()
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3: Void = await task3.value
    let _ = await "\(t1.debugDescription) \(t2.debugDescription)"
    let _ = await "\(t3)"

    #expect(dismissTrack == [1,2])
    #expect(sheetsRouter.sheets.count == 0)

}

@MainActor
@Test func testSheetsConcurent1() async throws {
    var dismissTrack: [Int] = []
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())

    let task1 = Task {
        await sheetsRouter.show(firstRoute) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetsRouter.show(firstRoute) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await sheetsRouter.hideAll()
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3: Void = await task3.value
    let _ = await "\(t1.debugDescription) \(t2.debugDescription)"
    let _ = await "\(t3)"

    #expect(dismissTrack == [2,1])
    #expect(sheetsRouter.sheets.count == 0)
}


@MainActor
@Test func testStackedSheetsDoNotRetainRouterThroughDismissHandler() async {
    var router: SheetsRouter<TestRoute>? = SheetsRouter(factory: MockSheetsRouterFactory())
    weak var sheet: SheetRouter<TestRoute>?
    await router?.show(.first)
    sheet = router?.sheets.first
    router = nil
    #expect(sheet == nil)
}

@MainActor
@Test func testHideAllDismissesParentOnceAndOrdersCallbacks() async {
    let router = SheetsRouter<TestRoute>()
    var callbacks: [Int] = []
    await router.show(.first) { callbacks.append(1) }
    await router.show(.second, sheetType: .fullScreen) { callbacks.append(2) }
    await router.show(.first) { callbacks.append(3) }
    let presenters = router.sheets

    let hide = Task { await router.hideAll() }
    while presenters[0].partialEntry != nil { await Task.yield() }
    #expect(presenters[1].fullScreenEntry != nil)
    #expect(presenters[2].partialEntry != nil)
    #expect(callbacks.isEmpty)

    // Descendant callbacks may arrive before the parent's callback.
    presenters[2].partialEntry = nil
    presenters[2].didDismissPartialSheet()
    #expect(callbacks.isEmpty)
    presenters[0].didDismissPartialSheet()
    await hide.value

    #expect(callbacks == [3, 2, 1])
    #expect(router.sheets.isEmpty)
    #expect(presenters.allSatisfy { !$0.isPresentingSheet })
    // Delayed SwiftUI callbacks must not repeat delivery.
    presenters[1].didDismissFullScreen()
    presenters[2].didDismissPartialSheet()
    presenters[0].didDismissPartialSheet()
    #expect(callbacks == [3, 2, 1])
}

@MainActor
@Test func testHideAtIndexDismissesOnlyTargetSubtree() async {
    let router = SheetsRouter<TestRoute>()
    var callbacks: [Int] = []
    await router.show(.first) { callbacks.append(1) }
    await router.show(.second, sheetType: .fullScreen) { callbacks.append(2) }
    await router.show(.first) { callbacks.append(3) }
    let presenters = router.sheets

    let hide = Task { await router.hide(index: 1) }
    while presenters[1].fullScreenEntry != nil { await Task.yield() }
    #expect(presenters[0].partialEntry != nil)
    #expect(presenters[2].partialEntry != nil)
    presenters[1].didDismissFullScreen()
    await hide.value

    #expect(callbacks == [3, 2])
    #expect(router.sheets.count == 1)
    #expect(router.sheets.first === presenters[0])
    #expect(presenters[0].isPresentingSheet)
}
