//
//  NavigationRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

extension NavigationRouter {
    /// Replaces the root destination while preserving the pushed path.
    /// - Parameter route: The new root destination.
    public func setRoot(_ route: T) {
        root = route
    }

    /// Appends a new occurrence of a destination to the navigation path.
    /// - Parameters:
    ///   - route: The destination to push.
    ///   - animated: Whether to allow the navigation transition to animate.
    public func push(_ route: T, animated: Bool = true) {
        runWithAnimation(animated: animated) {
            path.append(RouteEntry(route))
        }
    }

    /// Removes the last pushed destination. An empty path is unchanged.
    /// - Parameter animated: Whether to allow the navigation transition to animate.
    public func popLast(animated: Bool = true) {
        guard !path.isEmpty else { return }
        runWithAnimation(animated: animated) {
            path.removeLast()
        }
    }

    /// Removes all pushed destinations and displays the current root.
    /// - Parameter animated: Whether to allow the navigation transition to animate.
    public func popToRoot(animated: Bool = true) {
        runWithAnimation(animated: animated) {
            path.removeLast(path.count)
        }
    }
}
