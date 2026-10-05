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
    /// - Returns: The unique entry appended to the path.
    @discardableResult
    public func push(_ route: T, animated: Bool = true) -> RouteEntry<T> {
        let entry = RouteEntry(route)
        runWithAnimation(animated: animated) {
            path.append(entry)
        }
        return entry
    }

    /// Removes the last pushed destination. An empty path is unchanged.
    /// - Parameter animated: Whether to allow the navigation transition to animate.
    public func popLast(animated: Bool = true) {
        guard !path.isEmpty else {
            return
        }
        runWithAnimation(animated: animated) {
            path.removeLast()
        }
    }

    /// Removes an exact occurrence and every destination pushed after it.
    /// - Parameters:
    ///   - entry: An entry returned by `push`. An entry absent from this path does nothing.
    ///   - animated: Whether to allow the navigation transition to animate.
    public func pop(entry: RouteEntry<T>, animated: Bool = true) {
        guard let index = path.firstIndex(of: entry) else {
            return
        }
        runWithAnimation(animated: animated) {
            path.removeSubrange(index...)
        }
    }

    /// Returns to an exact occurrence, keeping it and removing destinations above it.
    /// - Parameters:
    ///   - entry: An entry returned by `push`. An entry absent from this path does nothing.
    ///   - animated: Whether to allow the navigation transition to animate.
    public func pop(to entry: RouteEntry<T>, animated: Bool = true) {
        guard let index = path.firstIndex(of: entry), index < path.count - 1 else {
            return
        }
        runWithAnimation(animated: animated) {
            path.removeSubrange((index + 1)...)
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
