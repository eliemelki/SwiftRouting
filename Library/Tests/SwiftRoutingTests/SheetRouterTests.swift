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
    let sheetRouter = MockSheetRouter()
    #expect(!sheetRouter.hasSheetDisplayed())
}

@MainActor
@Test func testSheetRouterFullShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.showFull(routable)
    sheetRouter.expectFull(routable)
}

@MainActor
@Test func testSheetRouterPartialShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.showPartial(routable)
    sheetRouter.expectPartial(routable)
    
}

@MainActor
@Test func testSheetRouterMultipleShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.showPartial(routable)
    await sheetRouter.showFull(routable)
    sheetRouter.expectFull(routable)
}

@MainActor
@Test func testSheetDismissHandler() async throws {
    var firstDismissCalled = false
    var secondDismissCalled = false
    var thirdDismissCalled = false
    
    let sheetRouter = MockSheetRouter()
    await sheetRouter.showPartial(routable) {
        firstDismissCalled = !firstDismissCalled
    }
    await sheetRouter.showFull(routable) {
        secondDismissCalled = !secondDismissCalled
    }
    #expect(firstDismissCalled)
    #expect(!secondDismissCalled)
    #expect(!thirdDismissCalled)
    
    
    await sheetRouter.showFull(routable) {
        thirdDismissCalled = !thirdDismissCalled
    }
    
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(!thirdDismissCalled)
    
    await sheetRouter.hide()
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(thirdDismissCalled)
    
    #expect(!sheetRouter.hasSheetDisplayed())
}

extension MockSheetRouter {
    
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
