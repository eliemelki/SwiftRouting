//
//  PageRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

extension PageRouter {
    /// Selects the first occurrence of a route; an unknown route does nothing.
    /// - Parameters:
    ///   - route: The destination to select.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(_ route: T, animated: Bool = true) {
        guard let entry = pages.first(where: { $0.route == route }) else { return }
        select(entry, animated: animated)
    }

    /// Selects an exact occurrence, including when routes repeat.
    /// - Parameters:
    ///   - entry: An entry from this router. An unknown entry does nothing.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(_ entry: RouteEntry<T>, animated: Bool = true) {
        guard pages.contains(entry), selection != entry else { return }
        runWithAnimation(animated: animated) {
            selection = entry
        }
    }

    /// Selects a destination by its zero-based display position.
    /// - Parameters:
    ///   - index: The position to select. Invalid indices do nothing.
    ///   - animated: Whether to allow the selection transition to animate.
    public func select(index: Int, animated: Bool = true) {
        guard pages.indices.contains(index) else { return }
        select(pages[index], animated: animated)
    }

    /// Selects the next page; the last page or an empty collection is unchanged.
    /// - Parameter animated: Whether to allow the page transition to animate.
    public func next(animated: Bool = true) {
        guard let selection, let index = pages.firstIndex(of: selection) else { return }
        select(index: index + 1, animated: animated)
    }

    /// Selects the previous page; the first page or an empty collection is unchanged.
    /// - Parameter animated: Whether to allow the page transition to animate.
    public func previous(animated: Bool = true) {
        guard let selection, let index = pages.firstIndex(of: selection) else { return }
        select(index: index - 1, animated: animated)
    }
}
