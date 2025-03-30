//
//  SheetCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

public enum SheetType {
    case fullScreen
    case partial
}

@MainActor
public protocol SheetCoordinator {

    @discardableResult
    func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    
    func hide(animated: Bool) async
    
    func hasSheetDisplayed() -> Bool
    
    func isDisplaying(_ routable: AnyRoutable) -> Bool
    
    //return nil if no sheet is displayed
    func sheetType() -> SheetType? 
    
}

@MainActor
public extension SheetCoordinator {
    func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool = true, dismissHandler:  SheetDismissHandler?) {
        Task {
            await self.show(routable, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        }
    }
    
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }
}
