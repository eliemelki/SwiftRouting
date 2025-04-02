//
//  SheetsCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//


/// Provides a convenient way to show hide as many views as a sheet.
@MainActor
public protocol SheetsCoordinator {
    
    /// Show a sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    ///
    @discardableResult
    func show<T: Routable>(_ routable: T, sheetType: SheetType, animated: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    
    /// Replace an sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    ///
    @discardableResult
    func replace<T: Routable>(_ routable: T, sheetType: SheetType, animated: Bool,onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    
    /// Hide a sheet sheet asycnhronusly
    /// - Parameters:
    ///   - animated: animate sheet hiding
    ///
    ///
    func hide(animated: Bool) async
    
    /// Hide a sheet sheet asycnhronusly
    /// - Parameters:
    ///   - index: hide the sheet at specific Index. if Index doesnt exist nothing should occurs.
    ///   - animated: animate sheet hiding
    ///
    func hide(index: Int, animated: Bool) async
    
    /// Hide a specific routable asycnhronusly.
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be dismissed. check `Routable` for more info.
    ///   - animated: animate sheet hiding
    ///
    ///
    func hide(routable: AnyRoutable, animated: Bool) async
    
    /// Hide all presented sheets.
    /// - Parameters:
    ///   - animated: animate sheet hiding
    ///
    ///
    func hideAll(animated: Bool) async
}

//Add some none async functions
@MainActor
public extension SheetsCoordinator {
    
    ///Same as show(...) async yet it doesnt needs an await
    func show<T: Routable>(_ routable: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) {
        Task {
            await self.show(routable, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    ///Same as replace(...) async yet it doesnt needs an await
    func replace<T: Routable>(_ routable: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) {
        Task {
            await self.replace(routable, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    ///Same as hide(...) async yet it doesnt needs an await
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }
    
    ///Same as hide(...) async yet it doesnt needs an await
    func hide(index: Int, animated: Bool = true)  {
        Task {
            await self.hide(index: index, animated: animated)
        }
    }
    
    ///Same as hide(...) async yet it doesnt needs an await
    func hide(routable: AnyRoutable, animated: Bool = true)  {
        Task {
            await self.hide(routable: routable, animated: animated)
        }
    }
    
    ///Same as hide(...) async yet it doesnt needs an await
    func hideAll(animated: Bool = true) {
        Task {
            await self.hideAll(animated: animated)
        }
    }
}


