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
    func push<T: Routable>(_ routable: T, animated: Bool)
    func popLast(animated: Bool)
    func popToRoot(animated: Bool)
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
    public func push<T: Routable>(_ routable: T, animated: Bool = true) {
        runWithAnimation(animated: animated) {
            paths.append(AnyRoutable(routable))
        }
    }
    
    /// pop last
    public func popLast(animated: Bool = true) {
        guard paths.count > 0 else {
            return
        }
        runWithAnimation(animated: animated) {
            paths.removeLast()
        }
    }
    
    /// pop to Root
    public func popToRoot(animated: Bool = true) {
        runWithAnimation(animated: animated) {
            paths.removeLast(self.paths.count)
        }
    }
}
