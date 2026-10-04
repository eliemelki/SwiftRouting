//
//  NavigationRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI

// MARK: - NavigationRouter - Routable

///NavigationRouter is also Routable
extension NavigationRouter {
    
    ///Create SheetsRouteView
    public func view<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> NavigationRouterView<T, V> {
        return NavigationRouterView<T,V>(router: self, makeView: makeView)
    }
}
