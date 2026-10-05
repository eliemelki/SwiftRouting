//
//  StateRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Observes a state router and replaces its destination when the route changes.
public struct StateRouterView<T: Route, V: View>: View {
    @ObservedObject private var router: StateRouter<T>
    private let makeView: @MainActor (T) -> V

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - makeView: Builds the destination on the main actor.
    public init(router: StateRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public var body: some View {
        makeView(router.route)
            .id(router.route)
    }
}
