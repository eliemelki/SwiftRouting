//
//  StackSheetsRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

import Foundation
import SwiftUI
import Testing

@testable import SwiftRouting

@MainActor
@Test func testStackSheetsRouterInitialState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    #expect(stackSheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testStackSheetsRouterShowState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 1)
    await stackSheetsRouter.hide()
    #expect(stackSheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testStackSheetsRouterMultipleShowState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 4)
    await stackSheetsRouter.hide()
    #expect(stackSheetsRouter.sheets.count == 3)
}

@MainActor
@Test func testStackSheetsRouterHideAllState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 4)
    await stackSheetsRouter.hideAll()
    #expect(stackSheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testStackSheetsRouterHideAtSpecificEntryState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    let entry = await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 4)
    await stackSheetsRouter.hide(entry: entry!)
    #expect(stackSheetsRouter.sheets.count == 2)
    await stackSheetsRouter.hide()
    #expect(stackSheetsRouter.sheets.count == 1)
}

@MainActor
@Test func testStackSheetsRouterHideState() async throws {
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 1)
    await stackSheetsRouter.hide()
    #expect(stackSheetsRouter.sheets.isEmpty)
    await stackSheetsRouter.show(firstRoute)
    await stackSheetsRouter.show(firstRoute)
    #expect(stackSheetsRouter.sheets.count == 2)
    await stackSheetsRouter.hide()
    #expect(stackSheetsRouter.sheets.count == 1)

}

@MainActor
@Test func testsSheetDismissHandler() async throws {
    var firstDismissCalled = false
    var secondDismissCalled = false
    var thirdDismissCalled = false

    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())

    await stackSheetsRouter.show(firstRoute) {
        firstDismissCalled = !firstDismissCalled
    }
    await stackSheetsRouter.show(firstRoute, sheetType: .fullScreen) {
        secondDismissCalled = !secondDismissCalled
    }

    await stackSheetsRouter.show(firstRoute, sheetType: .fullScreen) {
        thirdDismissCalled = !thirdDismissCalled
    }

    await stackSheetsRouter.hide()

    #expect(!firstDismissCalled)
    #expect(!secondDismissCalled)
    #expect(thirdDismissCalled)

    await stackSheetsRouter.hideAll()
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(thirdDismissCalled)

    #expect(stackSheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testSheetsConcurrent() async throws {
    var dismissTrack: [Int] = []
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())

    let task1 = Task {
        await stackSheetsRouter.show(firstRoute) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await stackSheetsRouter.replace(firstRoute) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await stackSheetsRouter.hide()
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3: Void = await task3.value
    let _ = await "\(t1.debugDescription) \(t2.debugDescription)"
    let _ = await "\(t3)"

    #expect(dismissTrack == [1, 2])
    #expect(stackSheetsRouter.sheets.count == 0)

}

@MainActor
@Test func testSheetsConcurent1() async throws {
    var dismissTrack: [Int] = []
    let stackSheetsRouter = StackSheetsRouter(factory: MockStackSheetsRouterFactory())

    let task1 = Task {
        await stackSheetsRouter.show(firstRoute) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await stackSheetsRouter.show(firstRoute) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await stackSheetsRouter.hideAll()
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3: Void = await task3.value
    let _ = await "\(t1.debugDescription) \(t2.debugDescription)"
    let _ = await "\(t3)"

    #expect(dismissTrack == [2, 1])
    #expect(stackSheetsRouter.sheets.count == 0)
}

@MainActor
@Test func testStackedSheetsDoNotRetainRouterThroughDismissHandler() async {
    var router: StackSheetsRouter<TestRoute>? = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    weak var sheet: SheetRouter<TestRoute>?
    await router?.show(.first)
    sheet = router?.sheets.first
    router = nil
    #expect(sheet == nil)
}

@MainActor
@Test func testHideAllDismissesParentOnceAndOrdersCallbacks() async {
    let router = StackSheetsRouter<TestRoute>()
    var callbacks: [Int] = []
    await router.show(.first) {
        callbacks.append(1)
    }
    await router.show(.second, sheetType: .fullScreen) {
        callbacks.append(2)
    }
    await router.show(.first) {
        callbacks.append(3)
    }
    let presenters = router.sheets

    let hide = Task {
        await router.hideAll()
    }
    while presenters[0].partialEntry != nil {
        await Task.yield()
    }
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
    #expect(
        presenters.allSatisfy {
            !$0.isPresentingSheet
        }
    )
    // Delayed SwiftUI callbacks must not repeat delivery.
    presenters[1].didDismissFullScreen()
    presenters[2].didDismissPartialSheet()
    presenters[0].didDismissPartialSheet()
    #expect(callbacks == [3, 2, 1])
}

@MainActor
@Test func testHideAtIndexDismissesOnlyTargetSubtree() async {
    let router = StackSheetsRouter<TestRoute>()
    var callbacks: [Int] = []
    await router.show(.first) {
        callbacks.append(1)
    }
    await router.show(.second, sheetType: .fullScreen) {
        callbacks.append(2)
    }
    await router.show(.first) {
        callbacks.append(3)
    }
    let presenters = router.sheets

    let hide = Task {
        await router.hide(index: 1)
    }
    while presenters[1].fullScreenEntry != nil {
        await Task.yield()
    }
    #expect(presenters[0].partialEntry != nil)
    #expect(presenters[2].partialEntry != nil)
    presenters[1].didDismissFullScreen()
    await hide.value

    #expect(callbacks == [3, 2])
    #expect(router.sheets.count == 1)
    #expect(router.sheets.first === presenters[0])
    #expect(presenters[0].isPresentingSheet)
}

@MainActor
@Test func testInvalidStackDismissalsPreservePresentationsAndCallbacks() async throws {
    let router = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    var callbacks = 0
    let entry = try #require(
        await router.show(.first) {
            callbacks += 1
        }
    )
    let presenter = try #require(router.sheets.first)
    await router.hide(index: -1)
    await router.hide(index: 1)
    await router.hide(entry: RouteEntry(TestRoute.first))
    #expect(router.sheets.count == 1)
    #expect(router.sheets.first === presenter)
    #expect(presenter.isDisplaying(entry))
    #expect(callbacks == 0)
    await router.hide(entry: entry)
    await router.hide(entry: entry)
    #expect(router.sheets.isEmpty)
    #expect(callbacks == 1)
}

@MainActor
@Test func testReplacingEmptyStackAndTopPreservesLowerEntry() async throws {
    let router = StackSheetsRouter(factory: MockStackSheetsRouterFactory())
    var callbacks: [Int] = []
    let bottom = try #require(
        await router.replace(.first) {
            callbacks.append(1)
        }
    )
    let top = try #require(
        await router.show(.second) {
            callbacks.append(2)
        }
    )
    let replacement = try #require(
        await router.replace(.second, sheetType: .fullScreen) {
            callbacks.append(3)
        }
    )
    #expect(replacement != top)
    #expect(router.sheets.count == 2)
    #expect(router.sheets[0].isDisplaying(bottom))
    #expect(router.sheets[1].isDisplaying(replacement))
    #expect(router.sheets[1].presentedSheetType == .fullScreen)
    #expect(callbacks == [2])
    await router.hideAll()
    await router.hideAll()
    #expect(callbacks == [2, 3, 1])
    #expect(router.sheets.isEmpty)
    #expect(!router.placeholderSheet.isPresentingSheet)
}
