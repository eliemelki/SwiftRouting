//
//  TabRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Renders typed destinations as tabs and synchronizes selection with the router.
public struct TabRouterView<T: Route, V: View, L: View>: View {
    @ObservedObject private var router: TabRouter<T>
    private let makeView: @MainActor (T) -> V
    private let makeLabel: @MainActor (T) -> L

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    ///   - makeLabel: Builds the title and icon for each tab item.
    public init(
        router: TabRouter<T>,
        @ViewBuilder makeView: @escaping @MainActor (T) -> V,
        @ViewBuilder makeLabel: @escaping @MainActor (T) -> L
    ) {
        self.router = router
        self.makeView = makeView
        self.makeLabel = makeLabel
    }

    public var body: some View {
        TabView(selection: $router.selection) {
            ForEach(router.tabs) { entry in
                makeView(entry.route)
                    .tabItem {
                        makeLabel(entry.route)
                    }
                    .tag(Optional(entry))
            }
        }
    }
}
