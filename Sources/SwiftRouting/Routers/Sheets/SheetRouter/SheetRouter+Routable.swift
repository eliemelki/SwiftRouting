//
//  SheetRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI


// MARK: - SheetViewFactory

@MainActor
protocol SheetViewFactory  {
    func createView<T>(content: @escaping () -> T) -> SheetRouterView<T> where T: View
}

// MARK: - SheetRouter - SheetViewFactory, Routable
///SheetRouter is also Routable
extension SheetRouter : SheetViewFactory, Routable, HashableByType {
    ///Create SheetRouteView
    public func createView() -> SheetRouterView<EmptyView> {
        return SheetRouterView(router: self, content: { EmptyView() })
    }
    
    func createView<T>(content: @escaping () -> T) -> SheetRouterView<T> where T : View {
        return SheetRouterView(router: self, content: content)
    }
}
