//
//  NavigationCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

@MainActor
public protocol NavigationCoordinator {
    
    func setMainViewFactory<T: Routable>(_ factory: T)
    
    func push<T: Routable>(_ factory: T)
    
    func popLast()
    
    func popToRoot()
}
