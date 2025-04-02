//
//  SheetCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

// MARK: - SheetType

/// SheetType, it can be either fullScreen or partial
public enum SheetType {
    ///Display in full screen mode
    case fullScreen
    ///Display in partial mode
    case partial
}

// MARK: - SheetCoordinator
public typealias SheetDismissHandler = () -> ()

/// Provides a convenient way for to show hide different type of sheet
@MainActor
public protocol SheetCoordinator {

    /// Show a sheet using async
    /// - Parameters:
    ///   - routable: Represent Routable object or any view that needs to be displayed. See @E
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    /// - Returns: An  `AnyRoutable` the internal earse typed object of routable created internally.
    @discardableResult
    func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable
    
    /// Hide a sheet sheet sycnhronusly
    /// - Parameters:
    ///   - animated: animate sheet showing
    ///
    ///
    func hide(animated: Bool) async
}

// MARK: - SheetCoordinator extensions

/// SheetCoordinator extension to provide a non async way to show and hide.
@MainActor
public extension SheetCoordinator {

    /// Hide Sheet non async
    /// - Parameters:
    ///   - animated: animate sheet showing
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }
    
    /// Show a sheet non async
    /// - Parameters:
    ///   - timeout: The amount of time that the current process will wait for the expectations to be mret
    ///   - sheetType: how to show sheet wether full or partial.
    ///   - animated: animate sheet showing
    ///   - dismissHandler: callback when sheet is dismissed. This get called when automatically or manually hiding the sheet. Manually as per calling hide explicitly.
    ///
    func show<T: Routable>(_ routable:T,
                           sheetType: SheetType = .partial,
                           animated: Bool = true,
                           dismissHandler:  SheetDismissHandler? = nil) {
        Task {
            await self.show(routable, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        }
    }
}

// MARK: - SheetCoordinatorHelpers

//This is some helper methods for internal use only.
@MainActor
protocol SheetCoordinatorHelpers {
    func hasSheetDisplayed() -> Bool
    
    func isDisplaying(_ routable: AnyRoutable) -> Bool
    
    //return nil if no sheet is displayed
    func sheetType() -> SheetType?
}
