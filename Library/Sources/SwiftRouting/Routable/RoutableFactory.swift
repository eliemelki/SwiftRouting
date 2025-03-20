//
//  RoutableFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//
import SwiftUI

public class RoutableFactory<V>: Routable, HashableByType where  V: View {
    public let resolver: () -> V
    public init(resolver: @escaping () -> V) {
        self.resolver = resolver
    }

    public func createView() -> V {
        return resolver()
    }
}
