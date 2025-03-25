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
