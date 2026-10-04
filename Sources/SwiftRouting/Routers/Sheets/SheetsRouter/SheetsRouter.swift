//
//  SheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

/// Coordinates a stack of typed sheet presentations using nested single-sheet routers.
/// Show, replace, and hide actions are serialized. Attach a sheets router view to
/// render the stack and deliver the dismissal callbacks that queued hides await.
@MainActor
public class SheetsRouter<T: Route>: ObservableObject {

    /// Single-sheet routers ordered from the bottom to the top of the stack.
    @Published var sheets: [SheetRouter<T>] = []
    /// An empty presenter nested above the stack, ready for the next sheet.
    @Published var placeholderSheet: SheetRouter<T>
    /// The queue that serializes changes to the presentation stack.
    public private(set) var queue: SerialQueue = .init()
    let factory: any SheetsRouterFactory<T>

    /// Creates an empty stack using the default single-sheet router factory.
    public convenience init() {
        self.init(factory: DefaultSheetsRouterFactory<T>())
    }

    init(factory: any SheetsRouterFactory<T>) {
        self.factory = factory
        self.placeholderSheet = factory.makeSheetRouter()
    }
}

extension SheetsRouter {
    /// Removes the dismissed presenter before notifying its owner.
    private func removeDismissedSheet(_ router: SheetRouter<T>, onDismiss: SheetDismissHandler?) {
        defer {
            onDismiss?()
        }
        var sheets = self.sheets
        sheets.removeAll { $0 === router }
        self.sheets = sheets
        self.placeholderSheet = factory.makeSheetRouter()
    }

    /// Waits for one presenter to complete its dismissal.
    func hidePresentations(_ sheet: SheetRouter<T>, animated: Bool) async {
       await sheet.hide(animated: animated)
    }

    /// Dismisses the top presenter if the stack is nonempty.
    func hidePresentations(animated: Bool = true) async {
        await self.hidePresentations(index: self.sheets.count - 1, animated: animated)
    }

    /// Dismisses a snapshot of presenters at and above an index.
    func hidePresentations(index: Int, animated: Bool = true) async {
        guard sheets.indices.contains(index) else { return }

        // Snapshot before awaiting: dismissal callbacks mutate the live array.
        let sheets = Array(self.sheets[index...])
        for sheet in sheets.reversed() {
            await self.hidePresentations(sheet, animated: animated)
        }
    }

    /// Promotes the placeholder to a presenter and prepares the next placeholder.
    @discardableResult
    func showPresentation(_ route: T, sheetType: SheetType = .partial, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T> {
        let currentSheet = self.placeholderSheet

        let nextSheetRouter: SheetRouter<T> = self.factory.makeSheetRouter()
        self.placeholderSheet = nextSheetRouter

        let handleDismissal = { [weak self, weak currentSheet] in
            guard let self, let currentSheet else { return }
            removeDismissedSheet(currentSheet, onDismiss: onDismiss)
        }

        self.sheets.append(currentSheet)

        return await currentSheet.show(route, sheetType: sheetType, animated: animated, onDismiss: handleDismissal)
    }
}

