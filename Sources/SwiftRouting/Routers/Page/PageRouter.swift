//
//  PageRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Coordinates selection among a fixed collection of pages.
@MainActor
public class PageRouter<T: Route>: ObservableObject {
    /// Stable occurrences ordered as they appear in the pager.
    public let pages: [RouteEntry<T>]
    /// The selected occurrence, or nil for an empty collection.
    /// User interaction and selection actions both update this property.
    @Published public internal(set) var selection: RouteEntry<T>?

    /// Creates a fixed collection and chooses an initial selection.
    /// - Parameters:
    ///   - pages: Destination values in display order. Repeated routes get distinct IDs.
    ///   - selected: The route to select first. Nil or an unknown route selects the first entry.
    public init(pages: [T], selected: T? = nil) {
        let entries = pages.map {
            RouteEntry($0)
        }
        self.pages = entries
        self.selection =
            entries.first {
                $0.route == selected
            } ?? entries.first

    }
}
