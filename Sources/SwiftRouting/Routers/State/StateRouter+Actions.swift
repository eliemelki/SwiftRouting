//
//  StateRouter+Actions.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

extension StateRouter {
    /// Replaces the current destination. Setting the current route does nothing.
    /// - Parameters:
    ///   - route: The destination to show.
    ///   - animated: Whether to allow the replacement to animate.
    public func set(_ route: T, animated: Bool = true) {
        guard self.route != route else {
            return
        }
        runWithAnimation(animated: animated) {
            self.route = route
        }
    }
}
