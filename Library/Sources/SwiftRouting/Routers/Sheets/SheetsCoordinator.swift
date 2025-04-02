//
//  SheetsCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//



@MainActor
public protocol SheetsCoordinator {
    @discardableResult
    func show<T: Routable>(_ item: T, sheetType: SheetType, animated: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    @discardableResult
    func replace<T: Routable>(_ item: T, sheetType: SheetType, animated: Bool,onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func hide(animated: Bool) async
    func hide(index: Int, animated: Bool) async
    func hide(routable: AnyRoutable, animated: Bool) async
    func hideAll(animated: Bool) async
}

//Add some none async functions
@MainActor
public extension SheetsCoordinator {
    
    func show<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) {
        Task {
            await self.show(item, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    func replace<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) {
        Task {
            await self.replace(item, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }
    func hide(index: Int, animated: Bool = true)  {
        Task {
            await self.hide(index: index, animated: animated)
        }
    }
    func hide(routable: AnyRoutable, animated: Bool = true)  {
        Task {
            await self.hide(routable: routable, animated: animated)
        }
    }
    func hideAll(animated: Bool = true) {
        Task {
            await self.hideAll(animated: animated)
        }
    }
}


