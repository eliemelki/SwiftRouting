//
//  SheetsRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//


// MARK: - SheetsRouter - Routable
///SheetsRouter is also Routable
extension SheetsRouter : Routable, HashableByType {
    ///Create SheetsRouteView
    public func createView() -> SheetsRouterView {
        return SheetsRouterView(router: self)
    }
}
