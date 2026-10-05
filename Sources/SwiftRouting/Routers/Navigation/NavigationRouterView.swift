//
//  NavigationRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI

/// Renders a root destination and a typed navigation path in a `NavigationStack`.
public struct NavigationRouterView<T: Route, V: View>: View {

    @ObservedObject private var router: NavigationRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: NavigationRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self._router = ObservedObject(wrappedValue: router)
        self.makeView = makeView
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            makeView(router.root)
                .navigationDestination(for: RouteEntry<T>.self) { entry in
                    makeView(entry.route)
                }
        }
    }
}
