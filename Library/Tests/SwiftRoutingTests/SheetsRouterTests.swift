//
//  File.swift
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
    await sheetsRouter.show(mockRoutable)
    #expect(sheetsRouter.sheets.count == 1)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.isEmpty)
}

@MainActor
@Test func testSheetsRouterMultipleShowState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.count == 3)
}

@MainActor
@Test func testSheetsRouterHideAllState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hideAll()
    #expect(sheetsRouter.sheets.isEmpty)
}


@MainActor
@Test func testSheetsRouterHideAtSpecificRoutableState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    let routable = await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
    #expect(sheetsRouter.sheets.count == 4)
    await sheetsRouter.hide(routable: routable!)
    #expect(sheetsRouter.sheets.count == 2)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.count == 1)
}

@MainActor
@Test func testSheetsRouterHideState() async throws {
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    await sheetsRouter.show(mockRoutable)
    #expect(sheetsRouter.sheets.count == 1)
    await sheetsRouter.hide()
    #expect(sheetsRouter.sheets.isEmpty)
    await sheetsRouter.show(mockRoutable)
    await sheetsRouter.show(mockRoutable)
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
    
    await sheetsRouter.show(mockRoutable) {
        firstDismissCalled = !firstDismissCalled
    }
    await sheetsRouter.show(mockRoutable, sheetType: .fullScreen) {
        secondDismissCalled = !secondDismissCalled
    }
    
    await sheetsRouter.show(mockRoutable, sheetType: .fullScreen) {
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
@Test func testSheetsConcurent() async throws {
    var dismissTrack: [Int] = []
    let sheetsRouter = SheetsRouter(factory: MockSheetsRouterFactory())
    
    let task1 = Task {
        await sheetsRouter.show(mockRoutable) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetsRouter.replace(mockRoutable) {
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
        await sheetsRouter.show(mockRoutable) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetsRouter.show(mockRoutable) {
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

