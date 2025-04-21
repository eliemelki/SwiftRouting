//
//  SheetRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI


// MARK: - SheetRouter - SheetViewFactory, Routable
///SheetRouter is also Routable
extension SheetRouter : Routable, HashableByType {
    ///Create SheetRouteView
    public func createView() -> SheetRouterView {
        return SheetRouterView(router: self)
    }
}



