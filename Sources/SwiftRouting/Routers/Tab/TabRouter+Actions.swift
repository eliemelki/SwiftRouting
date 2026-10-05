//
//  TabRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

extension TabRouter {
    /// Selects the first occurrence of a route; an unknown route does nothing.
    /// - Parameters:
    ///   - route: The destination to select.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(_ route: T, animated: Bool = true) {
        guard let entry = tabs.first(where: { $0.route == route }) else { return }
        select(entry, animated: animated)
    }

    /// Selects an exact occurrence, including when routes repeat.
    /// - Parameters:
    ///   - entry: An entry from this router. An unknown entry does nothing.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(_ entry: RouteEntry<T>, animated: Bool = true) {
        guard tabs.contains(entry), selection != entry else { return }
        runWithAnimation(animated: animated) {
            selection = entry
        }
    }

    /// Selects a destination by its zero-based display position.
    /// - Parameters:
    ///   - index: The position to select. Invalid indices do nothing.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(index: Int, animated: Bool = true) {
        guard tabs.indices.contains(index) else { return }
        select(tabs[index], animated: animated)
    }
}
