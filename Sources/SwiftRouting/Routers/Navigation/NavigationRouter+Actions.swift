//
//  NavigationRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

/// Provides a convenient way for to push pop views.
@MainActor
protocol NavigationActions {
    func setMain<T: Routable>(_ routable: T)
    func push<T: Routable>(_ routable: T)
    func popLast()
    func popToRoot()
}

extension NavigationRouter: NavigationActions {
    
    /// set the main view of a navigation
    /// Parameters:
    ///  - routable: Represent Routable object or any view that needs to be displayed.  check `Routable` for more info.
    public func setMain<T: Routable>(_ routable: T) {
        main = AnyRoutable(routable)
    }
    
    /// push a routable
    /// Parameters:
    ///  - routable:  Represent Routable object or any view that needs to be displayed. check `Routable` for more info.
    public func push<T: Routable>(_ routable: T) {
        paths.append(AnyRoutable(routable))
    }
    
    /// pop last
    public func popLast() {
        paths.removeLast()
    }
    
    /// pop to Root
    public func popToRoot() {
        paths.removeLast(self.paths.count)
    }
}
