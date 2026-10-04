//
//  NavigationRouterTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//
@testable import SwiftRouting
import Testing

@MainActor
@Test func testNavigationRouter() async throws {
    let router = NavigationRouter(main: mockRoutable)
    #expect(router.main == mockRoutable)
    #expect(router.paths.count == 0)
    
    router.setMain(mockRoutable)
    #expect(router.main == mockRoutable)
    #expect(router.paths.count == 0)
    
    
    router.push(mockRoutable)
    #expect(router.main == mockRoutable)
    #expect(router.paths.count == 1)
    #expect(router.paths[0].route == mockRoutable)
    
    router.popLast()
    router.popLast()
    #expect(router.paths.count == 0)
    
    router.push(mockRoutable, animated: false)
    router.push(mockRoutable)
    router.push(mockRoutable)
    #expect(router.paths.count == 3)
    
    router.popLast(animated: false)
    #expect(router.paths.count == 2)
    
    router.popToRoot()
    router.popToRoot(animated: false)
    #expect(router.paths.count == 0)
}
