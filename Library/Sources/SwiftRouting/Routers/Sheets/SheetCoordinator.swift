//
//  SheetCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

@MainActor
public protocol SheetCoordinator {
    @discardableResult
    func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    @discardableResult
    func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    func hide() async
    
    func hasSheetDisplayed() -> Bool
}

@MainActor
public extension SheetCoordinator {
    func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler?) {
        Task {
            await self.showPartial(routable, dismissHandler: dismissHandler)
        }
    }
    func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler?) {
        Task {
            await self.showFull(routable, dismissHandler: dismissHandler)
        }
    }
    func hide() {
        Task {
            await self.hide()
        }
    }
}
