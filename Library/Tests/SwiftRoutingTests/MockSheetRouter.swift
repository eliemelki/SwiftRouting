//
//  MockSheetRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//


@testable import SwiftRouting
import Combine

@MainActor
class MockSheetRouter {
    private let router = SheetRouter()
    var fullRoutableCancelable: AnyCancellable?
    var partialRoutableCancelable: AnyCancellable?
    
    var fullRoutable: AnyRoutable? {
        return router.fullRoutable
    }
    
    var partialRoutable: AnyRoutable? {
        return router.partialRoutable
    }

    
    init() {
        fullRoutableCancelable =
        router
            .$fullRoutable
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] value in
                if (value == nil) {
                    Task {
                        self?.router.dismissFullScreen()
                    }
                }
            }
        partialRoutableCancelable =
        router
            .$partialRoutable
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] value in
                if (value == nil) {
                    Task {
                        self?.router.dismissPartialScreen()
                    }
                }
            }
    }
}

extension MockSheetRouter: SheetCoordinator {
    @discardableResult
    func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable {
        await router.showPartial(routable, dismissHandler: dismissHandler)
    }
    
    @discardableResult
    func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable {
        await router.showFull(routable, dismissHandler: dismissHandler)
    }
    
    func hide() async {
        
        await router.hide()
        
    }
    
    public func hasSheetDisplayed() -> Bool {
        return router.hasSheetDisplayed()
    }
}
