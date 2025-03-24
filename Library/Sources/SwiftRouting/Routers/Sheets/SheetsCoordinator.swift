//
//  SheetsCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//


@MainActor
public protocol SheetsCoordinator {
    
    func show<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func replace<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func hide() async
    func hide(index: Int) async
    func hide(router: AnyRoutable) async
    func hideAll() async
}

//Add some none async functions
@MainActor
public extension SheetsCoordinator {
    
    func show<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHandler?) {
        Task {
            await self.show(item, isFullScreen: isFullScreen, onDismiss: onDismiss)
        }
    }
    func replace<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHandler?) {
        Task {
            await self.replace(item, isFullScreen: isFullScreen, onDismiss: onDismiss)
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
    func hide(router: AnyRoutable)  {
        Task {
            await self.hide(router: router)
        }
    }
    func hideAll() {
        Task {
            await self.hideAll()
        }
    }
}
