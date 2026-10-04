//
//  SheetRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

/// A callback invoked once after a sheet presentation is dismissed.
public typealias SheetDismissHandler = () -> Void

/// Coordinates one partial sheet or full-screen cover at a time.
/// Showing a new route waits for the existing presentation's dismissal callback.
/// Attach `view(makeView:)` or `sheetRouterView(_:makeView:)` to render destinations.
@MainActor
public class SheetRouter<T: Route>: ObservableObject {

    /// The callback belonging to the active full-screen occurrence.
    var onFullScreenDismiss: SheetDismissHandler?
    /// The callback belonging to the active partial-sheet occurrence.
    var onPartialDismiss: SheetDismissHandler?

    /// Resumes the queued hide after SwiftUI completes dismissal.
    private var dismissalCompletion: SheetDismissHandler?

    /// The full-screen presentation binding; nil when no full-screen entry is assigned.
    @Published public internal(set) var fullScreenEntry: RouteEntry<T>?
    /// The partial-sheet presentation binding; nil when no partial entry is assigned.
    @Published public internal(set) var partialEntry: RouteEntry<T>?

    /// Remains set while a cleared presentation binding is still dismissing.
    private var activeSheetType: SheetType?

    var queue: SerialQueue = .init()

    /// Creates a router with no active presentation.
    public init() {}
}

extension SheetRouter {

    /// Consumes the matching dismissal callback and resumes the queued operation.
    func finishDismissal(entry: RouteEntry<T>?, sheetType: SheetType, onDismiss: SheetDismissHandler?) {
        guard activeSheetType == sheetType, entry == nil else { return }
        let completion = dismissalCompletion
        activeSheetType = nil
        onFullScreenDismiss = nil
        onPartialDismiss = nil
        dismissalCompletion = nil
        onDismiss?()
        completion?()
    }

    /// Bridges SwiftUI dismissal completion into the queued async action.
    func hidePresentation(animated: Bool) async {
        await withCheckedContinuation { @MainActor continuation in
            self.hidePresentation(animated: animated) {
                continuation.resume()
            }
        }
    }

    /// Clears presentation entries and completes after the matching onDismiss callback.
    func hidePresentation(animated: Bool, completion: @escaping SheetDismissHandler) {
        // A swipe clears the binding before onDismiss. Still wait for that callback.
        guard activeSheetType != nil else {
            completion()
            return
        }
        self.dismissalCompletion = completion

        runWithAnimation(animated: animated) {
            self.partialEntry = nil
            self.fullScreenEntry = nil
        }
    }

    /// Queues replacement with a partial-sheet entry.
    @discardableResult
    func showPartial(_ route: T, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T> {
        let entry = RouteEntry(route)
        await queue.execute {
            await self.hidePresentation(animated: animated)
            self.runWithAnimation(animated: animated) {
                self.activeSheetType = .partial
                self.partialEntry = entry
                self.onPartialDismiss = onDismiss
            }
        }
        return entry
    }

    /// Queues replacement with a full-screen entry.
    @discardableResult
    func showFullScreen(_ route: T, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T> {
        let entry = RouteEntry(route)
        await queue.execute {
            await self.hidePresentation(animated: animated)
            self.runWithAnimation(animated: animated) {
                self.activeSheetType = .fullScreen
                self.fullScreenEntry = entry
                self.onFullScreenDismiss = onDismiss
            }
        }
        return entry
    }

}

