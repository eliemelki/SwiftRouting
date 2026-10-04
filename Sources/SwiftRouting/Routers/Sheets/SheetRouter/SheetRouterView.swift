//
//  SheetRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI

/// Adds a single-sheet presenter to existing content.
public struct SheetRouterViewModifier<T: Route, V: View> : ViewModifier {

    @ObservedObject var router: SheetRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.fullScreenEntry, onDismiss: self.router.didDismissFullScreen) { entry in
                makeView(entry.route)
            }.sheet(item: $router.partialEntry, onDismiss: self.router.didDismissPartialSheet) { entry in
                makeView(entry.route)
            }
    }
}

public extension View {
    /// Attaches a single-sheet presenter to this view.
    /// - Parameters:
    ///   - router: The externally owned router to observe.
    ///   - makeView: Builds each destination on the main actor.
    func sheetRouterView<T: Route, V: View>(_ router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) -> some View {
        modifier(SheetRouterViewModifier(router: router, makeView: makeView))
    }
}

/// Renders destinations for one partial sheet or full-screen cover.
public struct SheetRouterView<T: Route, V: View> : View {

    @ObservedObject var router: SheetRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public var body: some View {
        VStack{}.sheetRouterView(router, makeView: makeView)
    }
}
