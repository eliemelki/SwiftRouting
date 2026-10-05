//
//  StateRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Replaces the destination shown by its host without keeping navigation history.
@MainActor
public class StateRouter<T: Route>: ObservableObject {
    /// The destination currently shown by the host.
    @Published public internal(set) var route: T

    /// Creates a router showing the supplied initial destination.
    /// - Parameter route: The initial destination.
    public init(route: T) {
        self.route = route
    }
}
