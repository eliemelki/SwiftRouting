//
//  TabRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Coordinates selection among a fixed collection of tabs.
@MainActor
public class TabRouter<T: Route>: ObservableObject {
    /// Stable occurrences ordered as they appear in the tab bar.
    public let tabs: [RouteEntry<T>]
    /// The selected occurrence, or nil for an empty collection.
    /// User interaction and selection actions both update this property.
    @Published public internal(set) var selection: RouteEntry<T>?

    /// Creates a fixed collection and chooses an initial selection.
    /// - Parameters:
    ///   - tabs: Destination values in display order. Repeated routes get distinct IDs.
    ///   - selected: The route to select first. Nil or an unknown route selects the first entry.
    public init(tabs: [T], selected: T? = nil) {
        let entries = tabs.map {
            RouteEntry($0)
        }
        self.tabs = entries
        self.selection =
            entries.first {
                $0.route == selected
            } ?? entries.first
    }
}
