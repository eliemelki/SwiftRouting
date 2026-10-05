//
//  SheetRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

extension SheetRouter {
    /// Dismisses the current presentation and waits for its dismissal callback.
    /// Returns immediately when there is no active presentation.
    /// - Parameter animated: Whether to allow the dismissal transition to animate.
    public func hide(animated: Bool = true) async {
        await queue.execute { @MainActor [weak self] in
            await self?.hidePresentation(animated: animated)
        }
    }

    /// Dismisses any existing sheet, then assigns a new presentation entry.
    ///
    /// Calls are serialized. This method waits for the previous dismissal but
    /// returns after assigning the new entry, before its presentation animation finishes.
    /// Attach a sheet router view so SwiftUI can deliver dismissal callbacks.
    /// - Parameters:
    ///   - route: The destination to present.
    ///   - sheetType: A partial sheet or a full-screen cover.
    ///   - animated: Whether to allow dismissal and presentation animations.
    ///   - onDismiss: Called once when this presentation is dismissed, including replacement.
    /// - Returns: The unique entry assigned to this presentation.
    @discardableResult
    public func show(
        _ route: T,
        sheetType: SheetType = .partial,
        animated: Bool = true,
        onDismiss: SheetDismissHandler? = nil
    ) async -> RouteEntry<T> {
        await queue.execute {
            await self.showPresentation(
                route,
                sheetType: sheetType,
                animated: animated,
                onDismiss: onDismiss
            )
        }
    }

    /// Whether a sheet or full-screen cover has a non-nil presentation entry.
    /// Becomes false when dismissal begins; it does not track animation completion.
    public var isPresentingSheet: Bool {
        fullScreenEntry != nil || partialEntry != nil
    }

    /// Checks whether this exact occurrence is the current presentation entry.
    /// - Parameter entry: The occurrence returned by `show`.
    /// - Returns: Whether either presentation binding contains the entry.
    public func isDisplaying(_ entry: RouteEntry<T>) -> Bool {
        fullScreenEntry == entry || partialEntry == entry
    }

    /// The type of the current presentation entry, or nil when both bindings are empty.
    public var presentedSheetType: SheetType? {
        if fullScreenEntry != nil {
            return .fullScreen
        }
        if partialEntry != nil {
            return .partial
        }
        return nil
    }
}

public extension SheetRouter {
    /// Schedules dismissal in a task and returns without waiting.
    /// Use the async overload to wait for the dismissal callback.
    /// - Parameter animated: Whether to allow the dismissal transition to animate.
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }

    /// Schedules a presentation in a task and returns without waiting.
    /// Use the async overload to receive the presentation entry.
    /// - Parameters:
    ///   - route: The destination to present.
    ///   - sheetType: A partial sheet or a full-screen cover.
    ///   - animated: Whether to allow dismissal and presentation animations.
    ///   - onDismiss: Called once when this presentation is dismissed.
    func show(
        _ route: T,
        sheetType: SheetType = .partial,
        animated: Bool = true,
        onDismiss: SheetDismissHandler? = nil
    ) {
        Task {
            await self.show(
                route,
                sheetType: sheetType,
                animated: animated,
                onDismiss: onDismiss
            )
        }
    }
}
