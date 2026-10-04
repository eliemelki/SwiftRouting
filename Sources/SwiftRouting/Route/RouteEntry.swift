//
//  RouteEntry.swift
//  SwiftRouting
//
//  Created by Elie Melki on 02/10/2026.
//

import Foundation

/// A unique occurrence of a route in a path, sheet presentation, tab, or page.
///
/// Compare `route` for destination equality and `id` for occurrence identity.
/// Synthesized equality and hashing include both properties.
public struct RouteEntry<T: Route>: Identifiable, Hashable, Sendable {
    /// The occurrence ID, created once and retained for the entry's lifetime.
    public let id: UUID
    /// The destination represented by this occurrence.
    public let route: T

    /// Creates a new occurrence with a fresh ID, even when the route repeats.
    /// - Parameter route: The destination to store.
    public init(_ route: T) {
        id = UUID()
        self.route = route
    }
}
