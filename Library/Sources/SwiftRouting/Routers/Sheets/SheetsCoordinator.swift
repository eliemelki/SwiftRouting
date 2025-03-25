//
//  SheetsCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//



@MainActor
public protocol SheetsCoordinator {
    @discardableResult
    func show<T: Routable>(_ item: T, sheetType: SheetType, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    @discardableResult
    func replace<T: Routable>(_ item: T, sheetType: SheetType, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func hide() async
    func hide(index: Int) async
    func hide(routable: AnyRoutable) async
    func hideAll() async
}

//Add some none async functions
@MainActor
public extension SheetsCoordinator {
    
    func show<T: Routable>(_ item: T, sheetType: SheetType = .partial, onDismiss: SheetDismissHandler?) {
        Task {
            await self.show(item, sheetType: sheetType, onDismiss: onDismiss)
        }
    }
    func replace<T: Routable>(_ item: T, sheetType: SheetType = .partial, onDismiss: SheetDismissHandler?) {
        Task {
            await self.replace(item, sheetType: sheetType, onDismiss: onDismiss)
        }
    }
    func hide() {
        Task {
            await self.hide()
        }
    }
    func hide(index: Int)  {
        Task {
            await self.hide(index: index)
        }
    }
    func hide(routable: AnyRoutable)  {
        Task {
            await self.hide(routable: routable)
        }
    }
    func hideAll() {
        Task {
            await self.hideAll()
        }
    }
}

@MainActor
protocol SheetDismissable {
    func dismissFullScreen()
    func dismissPartialScreen()
}
