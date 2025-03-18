//
//  Routable.swift
//  SwiftRouting
//
//  Created by Elie Melki on 07/03/2025.
//

import SwiftUI

public typealias Routable = ViewFactory & Hashable & Identifiable

//Type Eraser
//Acts also as a wrapper for viewFactory
public class AnyRoutable: Routable, @unchecked Sendable {
    //We are pretty sure that the class is Thread safe as it act as immutable as its property are private and declared as let.
    //If that needs to be changed later we need to revisit the unchecked.
    
    private let base: (any Routable)
    private let equals: (any Routable) -> Bool
    
    public init<T: Routable>(_ routable: T) {
        self.base = routable
        self.equals = { other in
            guard let otherBase = other as? T else { return false }
            return routable == otherBase
        }
    }

    public func createView() -> some View {
        AnyView(base.createView())
    }

    open func hash(into hasher: inout Hasher) {
        self.base.hash(into: &hasher)
    }
    
    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.equals(rhs.base)
    }
}


public class RoutableFactory<V>: Routable, HashableByType where  V: View {
    public let resolver: () -> V
    public init(resolver: @escaping () -> V) {
        self.resolver = resolver
    }

    public func createView() -> V {
        return resolver()
    }
}
