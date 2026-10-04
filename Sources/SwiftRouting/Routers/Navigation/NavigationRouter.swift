//
//  NavigationRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 06/03/2025.
//

import SwiftUI

/// Coordinates a root destination and a typed navigation path.
///
/// Each push creates a new entry, allowing the same route to appear more than once.
/// Attach `view(makeView:)` to render the root and pushed destinations.
@MainActor
public class NavigationRouter<T: Route>: ObservableObject, Sendable {
    /// Pushed destinations, ordered from the root toward the visible destination.
    /// SwiftUI updates this array when the user navigates back.
    @Published public internal(set) var path: [RouteEntry<T>]
    /// The destination displayed below the pushed path.
    @Published public internal(set) var root: T

    /// Creates a router with a root destination and an empty path.
    /// - Parameter root: The initial root destination.
    public init(root: T) {
        self.path = []
        self.root = root
    }
}
