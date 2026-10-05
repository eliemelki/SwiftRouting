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
    private var onFullScreenDismiss: SheetDismissHandler?
    /// The callback belonging to the active partial-sheet occurrence.
    private var onPartialDismiss: SheetDismissHandler?

    /// Resumes the queued hide after SwiftUI completes dismissal.
    private var dismissalCompletion: SheetDismissHandler?

    /// The full-screen presentation binding; nil when no full-screen entry is assigned.
    @Published public internal(set) var fullScreenEntry: RouteEntry<T>?
    /// The partial-sheet presentation binding; nil when no partial entry is assigned.
    @Published public internal(set) var partialEntry: RouteEntry<T>?

    /// Remains set while a cleared presentation binding is still dismissing.
    private var activeSheetType: SheetType?

    // Stacked presenters use their owner's queue and never need this one.
    lazy var queue: SerialQueue = .init()

    /// Creates a router with no active presentation.
    public init() {
    }
}

extension SheetRouter {

    /// Consumes the matching dismissal callback and resumes the queued operation.
    private func finishDismissal(entry: RouteEntry<T>?, sheetType: SheetType, onDismiss: SheetDismissHandler?) {
        guard activeSheetType == sheetType, entry == nil else {
            return
        }
        let completion = dismissalCompletion
        activeSheetType = nil
        onFullScreenDismiss = nil
        onPartialDismiss = nil
        dismissalCompletion = nil
        onDismiss?()
        completion?()
    }

    /// Waits for dismissal without entering a queue; the caller must serialize changes.
    func hidePresentation(animated: Bool) async {
        await withCheckedContinuation { @MainActor continuation in
            self.hidePresentation(animated: animated) {
                continuation.resume()
            }
        }
    }

    /// Clears presentation entries and completes after the matching onDismiss callback.
    private func hidePresentation(animated: Bool, completion: @escaping SheetDismissHandler) {
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

    /// Transfers callback delivery to the stack owner before a parent dismissal.
    func takeDismissHandler() -> SheetDismissHandler? {
        let handler = onFullScreenDismiss ?? onPartialDismiss
        onFullScreenDismiss = nil
        onPartialDismiss = nil
        return handler
    }

    /// Clears a child presenter after its parent has finished dismissing the subtree.
    /// SwiftUI may already have delivered this child's callback; completion is idempotent.
    func finishDismissalAfterParent() {
        guard let sheetType = activeSheetType else {
            return
        }
        runWithAnimation(animated: false) {
            fullScreenEntry = nil
            partialEntry = nil
        }
        finishDismissal(entry: nil, sheetType: sheetType, onDismiss: nil)
    }

    /// Replaces the presentation without entering a queue.
    /// The caller must serialize this operation with any other presentation changes.
    @discardableResult
    func showPresentation(
        _ route: T,
        sheetType: SheetType,
        animated: Bool,
        onDismiss: SheetDismissHandler?
    ) async -> RouteEntry<T> {
        let entry = RouteEntry(route)
        await hidePresentation(animated: animated)
        runWithAnimation(animated: animated) {
            activeSheetType = sheetType
            switch sheetType {
            case .partial:
                onPartialDismiss = onDismiss
                partialEntry = entry
            case .fullScreen:
                onFullScreenDismiss = onDismiss
                fullScreenEntry = entry
            }
        }
        return entry
    }
}

extension SheetRouter {
    /// Handles SwiftUI completing a full-screen dismissal.
    func didDismissFullScreen() {
        finishDismissal(entry: self.fullScreenEntry, sheetType: .fullScreen, onDismiss: self.onFullScreenDismiss)
    }

    /// Handles SwiftUI completing a partial-sheet dismissal.
    func didDismissPartialSheet() {
        finishDismissal(entry: self.partialEntry, sheetType: .partial, onDismiss: self.onPartialDismiss)
    }
}
