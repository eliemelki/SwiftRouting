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
let routable = RoutableFactory() {
    return Text("Hello")
}

@MainActor
@Test func testSheetRouterInitialState() async throws {
    let sheetRouter = SheetRouter()
    #expect(!sheetRouter.hasSheetDisplayed())
}

@MainActor
@Test func testSheetRouterFullShow() async throws {
    let sheetRouter = SheetRouter()
    await sheetRouter.showFull(routable)
    sheetRouter.expectFull(routable)
}

@MainActor
@Test func testSheetRouterPartialShow() async throws {
    let sheetRouter = SheetRouter()
    await sheetRouter.showPartial(routable)
    sheetRouter.expectPartial(routable)
    
}

@MainActor
@Test func testSheetRouterMultipleShow() async throws {
    let sheetRouter = SheetRouter()
    await sheetRouter.showPartial(routable)
    await sheetRouter.showFull(routable)
    sheetRouter.expectFull(routable)
}

extension SheetRouter {
    
    func expectFull<T: Routable>(_ routable: T) {
        let fullRoutable = self.fullRoutable
        #expect(fullRoutable != nil)
        #expect(AnyRoutable(routable) == fullRoutable)
        
        let partialRoutable = self.partialRoutable
        #expect(partialRoutable == nil)
        #expect(self.hasSheetDisplayed())
    }
    
    func expectPartial<T: Routable>(_ routable: T) {
        let partialRoutable = self.partialRoutable
        #expect(partialRoutable != nil)
        #expect(AnyRoutable(routable) == partialRoutable)
        
        let fullRoutable = self.fullRoutable
        #expect(fullRoutable == nil)
        #expect(self.hasSheetDisplayed())
    }
}
