//
//  NavigationCoordinator.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

/// Provides a convenient way for to push pop views.
@MainActor
public protocol NavigationCoordinator {
    
    /// set the main view of a navigation
    /// Parameters:
    ///  - routable: Represent Routable object or any view that needs to be displayed.  check `Routable` for more info.
    func setMain<T: Routable>(_ routable: T)
    
    /// push a routable
    /// Parameters:
    ///  - routable:  Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    func push<T: Routable>(_ routable: T)
    
    /// pop last
    func popLast()
    
    /// pop to Root
    func popToRoot()
}
