//
//  SheetsRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

// MARK: - SheetsActions

/// Async actions for a stack of typed sheet presentations.
@MainActor
public protocol SheetsActions {
    /// The destination value accepted by presentation actions.
    associatedtype T: Route

    /// See the corresponding async method on `SheetsRouter`.
    @discardableResult
    func show(_ route: T, sheetType: SheetType, animated: Bool, onDismiss: SheetDismissHandler?) async -> RouteEntry<T>?

    /// See the corresponding async method on `SheetsRouter`.
    @discardableResult
    func replace(_ route: T, sheetType: SheetType, animated: Bool, onDismiss: SheetDismissHandler?) async -> RouteEntry<T>?

    /// See the corresponding async method on `SheetsRouter`.
    func hide(animated: Bool) async

    /// See the corresponding async method on `SheetsRouter`.
    func hide(index: Int, animated: Bool) async

    /// See the corresponding async method on `SheetsRouter`.
    func hide(entry: RouteEntry<T>, animated: Bool) async

    /// See the corresponding async method on `SheetsRouter`.
    func hideAll(animated: Bool) async
}

// MARK: - SheetsRouter - SheetsActions

extension SheetsRouter: SheetsActions {

    /// Adds a new sheet above the current stack and assigns its presentation entry.
    /// Calls are serialized; this returns before the presentation animation finishes.
    /// - Parameters:
    ///   - route: The destination to present.
    ///   - sheetType: A partial sheet or a full-screen cover.
    ///   - animated: Whether to allow the presentation transition to animate.
    ///   - onDismiss: Called once after this sheet is removed from the stack.
    /// - Returns: The new occurrence, or nil if the router is unavailable when its queued action runs.
    @discardableResult
    public func show(_ route: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T>? {
        return await queue.execute { @MainActor [weak self] in
            return await self?.showPresentation(route, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }

    /// Dismisses the top sheet, waits for its callback, then presents a new destination.
    /// With an empty stack, behaves like `show`.
    /// - Parameters:
    ///   - route: The replacement destination.
    ///   - sheetType: A partial sheet or a full-screen cover.
    ///   - animated: Whether to allow dismissal and presentation animations.
    ///   - onDismiss: Called once after the replacement sheet is removed.
    /// - Returns: The new occurrence, or nil if the router is unavailable when its queued action runs.
    @discardableResult
    public func replace(_ route: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T>? {
        return await queue.execute { [weak self] in
            await self?.hidePresentations(animated: animated)
            return await self?.showPresentation(route, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }

    /// Dismisses the top sheet and waits for its dismissal callback.
    /// An empty stack is unchanged.
    /// - Parameter animated: Whether to allow the dismissal transition to animate.
    public func hide(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?.hidePresentations(animated: animated)
        }
    }

    /// Dismisses the bottom sheet and its subtree in one transition.
    /// After it completes, delivers dismissal handlers from top to bottom.
    /// - Parameter animated: Whether to allow the dismissal transitions to animate.
    public func hideAll(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?.hidePresentations(index: 0, animated: animated)
        }
    }

    /// Dismisses the sheet at an index and its subtree in one transition.
    /// After it completes, delivers dismissal handlers from top to bottom.
    /// - Parameters:
    ///   - index: A zero-based position from the bottom of the stack. Invalid indices do nothing.
    ///   - animated: Whether to allow the dismissal transitions to animate.
    public func hide(index: Int, animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?.hidePresentations(index: index, animated: animated)
        }
    }

    /// Dismisses an exact occurrence and its subtree in one transition.
    /// After it completes, delivers dismissal handlers from top to bottom.
    /// - Parameters:
    ///   - entry: The occurrence returned by `show` or `replace`. Unknown entries do nothing.
    ///   - animated: Whether to allow the dismissal transitions to animate.
    public func hide(entry: RouteEntry<T>, animated: Bool = true) async {
        await queue.execute { [weak self] in
            let index = self?.sheets.firstIndex { $0.isDisplaying(entry) }
            guard let index else {
                return
            }
            await self?.hidePresentations(index: index, animated: animated)
        }
    }
}

public extension SheetsRouter {

    /// Schedules `show` in a task; use the async overload to receive its entry.
    /// Parameters have the same meaning as in the async overload.
    func show(_ route: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) {
        Task {
            await self.show(route, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }

    /// Schedules `replace` in a task; use the async overload to receive its entry.
    /// Parameters have the same meaning as in the async overload.
    func replace(_ route: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) {
        Task {
            await self.replace(route, sheetType: sheetType, animated: animated, onDismiss: onDismiss)
        }
    }

    /// Schedules dismissal of the top sheet without waiting for its callback.
    /// - Parameter animated: Whether to allow the dismissal transition to animate.
    func hide(animated: Bool = true) {
        Task {
            await self.hide(animated: animated)
        }
    }

    /// Schedules dismissal at an index and above without waiting for callbacks.
    /// - Parameters:
    ///   - index: A zero-based stack position. Invalid indices do nothing.
    ///   - animated: Whether to allow the dismissal transitions to animate.
    func hide(index: Int, animated: Bool = true) {
        Task {
            await self.hide(index: index, animated: animated)
        }
    }

    /// Schedules dismissal of an occurrence and above without waiting for callbacks.
    /// - Parameters:
    ///   - entry: The presentation occurrence. Unknown entries do nothing.
    ///   - animated: Whether to allow the dismissal transitions to animate.
    func hide(entry: RouteEntry<T>, animated: Bool = true) {
        Task {
            await self.hide(entry: entry, animated: animated)
        }
    }

    /// Schedules dismissal of all sheets without waiting for callbacks.
    /// - Parameter animated: Whether to allow the dismissal transitions to animate.
    func hideAll(animated: Bool = true) {
        Task {
            await self.hideAll(animated: animated)
        }
    }
}
