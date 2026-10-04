//
//  ViewFactory 2.swift
//  SwiftRouting
//
//  Created by Elie Melki on 02/10/2026.
//


import Foundation
import SwiftUI


/// A single occurrence of a destination. Compare `route` for destination equality,
/// or `id` for occurrence identity. New entries always receive fresh IDs.
public struct RouteEntry<T: Route>: Identifiable, Hashable {
    public let id: UUID
    public let route: T

    public init(_ route: T) {
        id = UUID()
        self.route = route
    }
}

extension RouteEntry: Sendable where Route: Sendable {}



