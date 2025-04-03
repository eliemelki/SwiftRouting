//
//  SheetsRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

// MARK: - SheetsActions

@MainActor
public protocol SheetsActions {
    
    @discardableResult
    func show<T: Routable>(_ routable: T, sheetType: SheetType, animated: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    
    @discardableResult
    func replace<T: Routable>(_ routable: T, sheetType: SheetType, animated: Bool,onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    
    func hide(animated: Bool) async
    
 
    func hide(index: Int, animated: Bool) async
    
    func hide(routable: AnyRoutable, animated: Bool) async
    
    func hideAll(animated: Bool) async
}

// MARK: - SheetsRouter - SheetsActions

extension SheetsRouter: SheetsActions {
    
    /// Show a sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    ///
    @discardableResult
    public func show<T: Routable>(_ item: T,  sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable? {
        return await queue.execute { @MainActor [weak self] in
            return await self?._show(item, sheetType:sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    /// Replace an sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    ///
    @discardableResult
    public func replace<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) async -> AnyRoutable? {
        return await queue.execute { [weak self] in
            await self?._hide(animated: animated)
            return await self?._show(item, sheetType:sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    /// Hide a sheet sheet asycnhronusly
    /// - Parameters:
    ///   - animated: animate sheet hiding
    ///
    ///
    public func hide(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(animated: animated)
        }
    }
    
    /// Hide a sheet sheet asycnhronusly
    /// - Parameters:
    ///   - index: hide the sheet at specific Index. if Index doesnt exist nothing should occurs.
    ///   - animated: animate sheet hiding
    ///
    public func hideAll(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(index: 0, animated: animated)
        }
    }
    
    /// Hide a specific routable asycnhronusly.
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be dismissed. check `Routable` for more info.
    ///   - animated: animate sheet hiding
    ///
    ///
    public func hide(index: Int, animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(index: index, animated: animated)
        }
    }
    
    /// Hide all presented sheets.
    /// - Parameters:
    ///   - animated: animate sheet hiding
    ///
    ///
    public func hide(routable: AnyRoutable,animated: Bool = true) async {
        await queue.execute { [weak self] in
            let index = self?.sheets.firstIndex { $0.isDisplaying(routable) }
            guard let index else {
                return
            }
            await self?._hide(index: index, animated: animated)
        }
    }
}


public extension SheetsRouter {
    
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
