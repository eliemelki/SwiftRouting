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
let mockRoutable2 = RoutableFactory() {
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

@MainActor
@Test func testSheetConcurent() async throws {
    var dismissTrack: [Int] = []
 
    
    let sheetRouter = MockSheetRouter()
    let task1 = Task {
        await sheetRouter.show(mockRoutable) {
            dismissTrack.append(1)
        }
    }
    let task2 = Task {
        await sheetRouter.show(mockRoutable, sheetType: .fullScreen) {
            dismissTrack.append(2)
        }
    }
    let task3 = Task {
        await sheetRouter.show(mockRoutable2, sheetType: .fullScreen) {
            dismissTrack.append(3)
        }
    }
    async let t1 = await task1.value
    async let t2 = await task2.value
    async let t3 = await task3.value
    let _ = await "\(t1) \(t2) \(t3)"
    #expect(dismissTrack == [1,2])
    #expect(sheetRouter.proxy.fullRoutable == AnyRoutable(mockRoutable2))
    
    let task4 = Task {
        await sheetRouter.hide()
        return 4
    }
    
   
    async let t4 = await task4.value
    
    let _ = await "\(t4)"
    
    #expect(dismissTrack == [1,2,3])
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
