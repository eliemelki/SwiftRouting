//
//  NavigationRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

// MARK: - NavigationRouter - Routable

///NavigationRouter is also Routable
extension NavigationRouter : Routable, HashableByType {
    ///Create SheetsRouteView
    public func createView() -> NavigationRouterView {
        return NavigationRouterView(router: self)
    }
}
