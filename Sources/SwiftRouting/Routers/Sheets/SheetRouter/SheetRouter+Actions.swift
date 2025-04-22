//
//  SheetActions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

// MARK: - SheetActions

@MainActor
protocol SheetActions {
    @discardableResult
    func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    func hide(animated: Bool) async
    func hasSheetDisplayed() -> Bool
    func isDisplaying(_ routable: AnyRoutable) -> Bool
    func sheetType() -> SheetType?
}


// MARK: - SheetRouter - SheetActions
extension SheetRouter: SheetActions {
    
    /// Hide a sheet sheet sycnhronusly
    /// - Parameters:
    ///   - animated: animate sheet showing
    ///
    ///
    public func hide(animated: Bool) async {
        await queue.execute { @MainActor [weak self] in
            await self?._hide(animated: animated)
        }
    }
   
    /// Show a sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. . check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    @discardableResult
    public func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool = true, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable {
        switch sheetType {
        case .fullScreen:
            await self.showFull(routable, animated: animated, dismissHandler: dismissHandler)
        case .partial:
            await self.showPartial(routable, animated: animated, dismissHandler: dismissHandler)
        }
    }
    
    func hasSheetDisplayed() -> Bool {
        return fullRoutable != nil || partialRoutable != nil
    }
    
    func isDisplaying(_ routable: AnyRoutable) -> Bool {
        return fullRoutable === routable || partialRoutable === routable
    }
    
    
    func sheetType() -> SheetType? {
        if fullRoutable != nil {
            return .fullScreen
        } else if partialRoutable != nil {
            return .partial
        }
        return nil
    }
}

// MARK: - SheetRouter - Helpers

public extension SheetRouter {
    /// /// Same as Hide async but it wraps in a Task so we dont await.
    /// - Parameters:
    ///   - animated: animate sheet showing
    ///
    ///
    func hide(animated: Bool = true)  {
        Task {
            await self.hide(animated: animated)
        }
    }
   
    /// Same as Show async but it wraps in a Task so we dont await.
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. . check `Routable` for more info.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.

    func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool = true, dismissHandler:  SheetDismissHandler?) {
        Task {
            await self.show(routable, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        }
    }
    
}

