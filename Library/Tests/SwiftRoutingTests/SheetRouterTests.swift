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
let mockRoutable = RoutableFactory() {
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
    await sheetRouter.show(mockRoutable, sheetType: .fullScreen)
    sheetRouter.expectFull(mockRoutable)
}

@MainActor
@Test func testSheetRouterPartialShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(mockRoutable)
    sheetRouter.expectPartial(mockRoutable)
    
}

@MainActor
@Test func testSheetRouterMultipleShow() async throws {
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(mockRoutable)
    await sheetRouter.show(mockRoutable, sheetType: .fullScreen)
    sheetRouter.expectFull(mockRoutable)
}

@MainActor
@Test func testSheetDismissHandler() async throws {
    var firstDismissCalled = false
    var secondDismissCalled = false
    var thirdDismissCalled = false
    
    let sheetRouter = MockSheetRouter()
    await sheetRouter.show(mockRoutable) {
        firstDismissCalled = !firstDismissCalled
    }
    await sheetRouter.show(mockRoutable, sheetType: .fullScreen) {
        secondDismissCalled = !secondDismissCalled
    }
    #expect(firstDismissCalled)
    #expect(!secondDismissCalled)
    #expect(!thirdDismissCalled)
    
    
    await sheetRouter.show(mockRoutable, sheetType: .fullScreen) {
        thirdDismissCalled = !thirdDismissCalled
    }
    
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(!thirdDismissCalled)
    
    await sheetRouter.hide()
    #expect(firstDismissCalled)
    #expect(secondDismissCalled)
    #expect(thirdDismissCalled)
    #expect(sheetRouter.sheetType() == nil)
    #expect(!sheetRouter.hasSheetDisplayed())
}

extension MockSheetRouter {
    
    func expectFull<T: Routable>(_ routable: T) {
        let fullRoutable = self.proxy.fullRoutable
        #expect(fullRoutable != nil)
        #expect(AnyRoutable(routable) == fullRoutable)
        #expect(self.sheetType() == .fullScreen)
        
        let partialRoutable = self.proxy.partialRoutable
        #expect(partialRoutable == nil)
        #expect(self.hasSheetDisplayed())
    }
    
    func expectPartial<T: Routable>(_ routable: T) {
        let partialRoutable = self.proxy.partialRoutable
        #expect(partialRoutable != nil)
        #expect(AnyRoutable(routable) == partialRoutable)
        
        let fullRoutable = self.proxy.fullRoutable
        #expect(fullRoutable == nil)
        #expect(self.hasSheetDisplayed())
    }
}
