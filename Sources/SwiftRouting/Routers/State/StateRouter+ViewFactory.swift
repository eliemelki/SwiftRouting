//
//  StateRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

extension StateRouter {
    /// Creates a host that displays the current destination using a typed view builder.
    /// - Parameter makeView: Builds the destination on the main actor.
    public func view<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> StateRouterView<T, V> {
        StateRouterView(router: self, makeView: makeView)
    }
}
