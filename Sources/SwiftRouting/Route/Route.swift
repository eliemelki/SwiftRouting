//
//  Route.swift
//  SwiftRouting
//
//  Created by Elie Melki on 07/03/2025.
//

/// A destination value stored by a router.
///
/// Use an enum or struct with stable hashing. Build its SwiftUI view separately
/// in the router's view-builder closure. Routes must be safe to send across tasks.
public typealias Route = Hashable & Sendable
