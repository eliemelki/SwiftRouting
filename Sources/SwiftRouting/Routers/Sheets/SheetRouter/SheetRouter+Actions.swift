//
//  SheetActions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

// MARK: - SheetActions

@MainActor
protocol SheetActions {
    associatedtype T: Route
    @discardableResult
    func show(_ route:T, sheetType: SheetType, animated: Bool, dismissHandler:  SheetDismissHandler?) async -> RouteEntry<T>
    func hide(animated: Bool) async
    func hasSheetDisplayed() -> Bool
    func isDisplaying(_ route: RouteEntry<T>) -> Bool
    func sheetType() -> SheetType?
}


// MARK: - SheetRouter - SheetActions
extension SheetRouter: SheetActions {
    /// Hide a sheet sheet sycnhronusly
    /// - Parameters:
    ///   - animated: animate sheet showing
    ///
    ///
    public func hide(animated: Bool = true) async {
        await queue.execute { @MainActor [weak self] in
            await self?._hide(animated: animated)
        }
    }
   
    /// Show a sheet using async
    /// - Parameters:
    ///   - route: The destination to display.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: The unique entry for this presentation.
    @discardableResult
    public func show(_ route:T, sheetType: SheetType = .partial, animated: Bool = true, dismissHandler:  SheetDismissHandler? = nil) async -> RouteEntry<T> {
        switch sheetType {
        case .fullScreen:
            await self.showFull(route, animated: animated, dismissHandler: dismissHandler)
        case .partial:
            await self.showPartial(route, animated: animated, dismissHandler: dismissHandler)
        }
    }
    
    func hasSheetDisplayed() -> Bool {
        return fullRoutable != nil || partialRoutable != nil
    }
    
    func isDisplaying(_ routable: RouteEntry<T>) -> Bool {
        return fullRoutable == routable || partialRoutable == routable
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
    ///   - route: The destination to display.
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.

    func show(_ route:T, sheetType: SheetType = .partial, animated: Bool = true, dismissHandler:  SheetDismissHandler? = nil) {
        Task {
            await self.show(route, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        }
    }
    
}

