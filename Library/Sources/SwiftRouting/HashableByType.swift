//
//  HashableByType.swift
//  SwiftRouting
//
//  Created by Elie Melki on 08/03/2025.
//
import Foundation


public protocol HashableByType: Hashable {}

extension HashableByType where Self: Identifiable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
