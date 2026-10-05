//
//  StackSheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

/// Coordinates a stack of typed sheet presentations using nested single-sheet routers.
/// Show, replace, and hide actions are serialized. Attach a sheets router view to
/// render the stack and deliver the dismissal callbacks that queued hides await.
@MainActor
public class StackSheetsRouter<T: Route>: ObservableObject {

    /// Single-sheet routers ordered from the bottom to the top of the stack.
    @Published private(set) var sheets: [SheetRouter<T>] = []
    /// An empty presenter nested above the stack, ready for the next sheet.
    @Published private(set) var placeholderSheet: SheetRouter<T>
    /// The queue that serializes changes to the presentation stack.
    public private(set) var queue: SerialQueue = .init()
    private let factory: any StackSheetsRouterFactory<T>

    /// Creates an empty stack using the default single-sheet router factory.
    public convenience init() {
        self.init(factory: DefaultStackSheetsRouterFactory<T>())
    }

    init(factory: any StackSheetsRouterFactory<T>) {
        self.factory = factory
        self.placeholderSheet = factory.makeSheetRouter()
    }
}

extension StackSheetsRouter {
    /// Removes the dismissed presenter before notifying its owner.
    private func removeDismissedSheet(_ router: SheetRouter<T>, onDismiss: SheetDismissHandler?) {
        defer {
            onDismiss?()
        }
        var sheets = self.sheets
        sheets.removeAll {
            $0 === router
        }
        self.sheets = sheets
        self.placeholderSheet = factory.makeSheetRouter()
    }

    /// Dismisses the top presenter if the stack is nonempty.
    func hidePresentations(animated: Bool = true) async {
        await self.hidePresentations(index: self.sheets.count - 1, animated: animated)
    }

    /// Dismisses the target presenter once, then completes callbacks from top to bottom.
    func hidePresentations(index: Int, animated: Bool = true) async {
        guard sheets.indices.contains(index) else {
            return
        }

        let dismissedSheets = Array(sheets[index...])
        // SwiftUI can deliver descendant onDismiss callbacks in any order.
        // Detach them first so the stack owns their order and delivers each once.
        let handlers = dismissedSheets.map {
            $0.takeDismissHandler()
        }
        await dismissedSheets[0].hidePresentation(animated: animated)

        for (sheet, handler) in zip(dismissedSheets, handlers).reversed() {
            sheet.finishDismissalAfterParent()
            handler?()
        }
    }

    /// Promotes the placeholder and presents directly under the stack's queue.
    /// Call only from a serialized stack action.
    @discardableResult
    func showPresentation(
        _ route: T,
        sheetType: SheetType = .partial,
        animated: Bool,
        onDismiss: SheetDismissHandler? = nil
    ) async -> RouteEntry<T> {
        let currentSheet = self.placeholderSheet

        let nextSheetRouter: SheetRouter<T> = self.factory.makeSheetRouter()
        self.placeholderSheet = nextSheetRouter

        let handleDismissal = { [weak self, weak currentSheet] in
            guard let self, let currentSheet else {
                return
            }
            removeDismissedSheet(currentSheet, onDismiss: onDismiss)
        }

        self.sheets.append(currentSheet)

        return await currentSheet.showPresentation(
            route,
            sheetType: sheetType,
            animated: animated,
            onDismiss: handleDismissal
        )
    }
}
