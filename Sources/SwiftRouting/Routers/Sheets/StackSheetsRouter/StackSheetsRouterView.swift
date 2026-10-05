//
//  StackSheetsRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Adds nested sheet presenters to existing content.
public struct StackSheetsRouterViewModifier<T: Route, V: View>: ViewModifier {
    @ObservedObject private var router: StackSheetsRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: StackSheetsRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public func body(content: Content) -> some View {
        content.modifier(
            NestedSheetRouterViewModifier(
                sheets: router.sheets + [router.placeholderSheet],
                makeView: makeView
            )
        )
    }
}

public extension View {
    /// Attaches nested sheet presenters to this view.
    /// - Parameters:
    ///   - router: The externally owned router to observe.
    ///   - makeView: Builds each destination on the main actor.
    func stackSheetsRouterView<T: Route, V: View>(
        _ router: StackSheetsRouter<T>,
        @ViewBuilder makeView: @escaping @MainActor (T) -> V
    ) -> some View {
        modifier(StackSheetsRouterViewModifier(router: router, makeView: makeView))
    }
}

/// Renders a stack of nested sheet presentations.
public struct StackSheetsRouterView<T: Route, V: View>: View {
    @ObservedObject private var router: StackSheetsRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: StackSheetsRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public var body: some View {
        VStack {
        }.stackSheetsRouterView(router, makeView: makeView)
    }
}

// A named recursive view keeps the nested presentation type finite without AnyView.
private struct NestedSheetRouterViewModifier<T: Route, V: View>: ViewModifier {
    let sheets: [SheetRouter<T>]
    let makeView: @MainActor (T) -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if let sheet = sheets.first {
            content.sheetRouterView(sheet) { route in
                NestedSheetContent(route: route, sheets: Array(sheets.dropFirst()), makeView: makeView)
            }
        } else {
            content
        }
    }
}

private struct NestedSheetContent<T: Route, V: View>: View {
    let route: T
    let sheets: [SheetRouter<T>]
    let makeView: @MainActor (T) -> V

    var body: some View {
        makeView(route).modifier(NestedSheetRouterViewModifier(sheets: sheets, makeView: makeView))
    }
}
