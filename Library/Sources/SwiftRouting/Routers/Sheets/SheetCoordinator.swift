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
    func show<T: Routable>(_ routable:T, sheetType: SheetType, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    
    func hide() async
    
    func hasSheetDisplayed() -> Bool
    
    func isDisplaying(_ routable: AnyRoutable) -> Bool
    
    //return nil if no sheet is displayed
    func sheetType() -> SheetType? 
    
}

@MainActor
public extension SheetCoordinator {
    func show<T: Routable>(_ routable:T, sheetType: SheetType, dismissHandler:  SheetDismissHandler?) {
        Task {
            await self.show(routable, sheetType: sheetType, dismissHandler: dismissHandler)
        }
    }
    
    func hide() {
        Task {
            await self.hide()
        }
    }
}
