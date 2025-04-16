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
    func createView<T>(sheetContent: @escaping (AnyRoutable) -> T) -> SheetRouterViewModifier<T>
}

// MARK: - SheetRouter - SheetViewFactory, Routable
///SheetRouter is also Routable
extension SheetRouter : SheetViewFactory, Routable, HashableByType {
    ///Create SheetRouteView
    public func createView() -> SheetRouterView<EmptyView> {
        return SheetRouterView(router: self)
    }
  
    func createView<T>(sheetContent: @escaping (AnyRoutable) -> T) -> SheetRouterViewModifier<T> {
        SheetRouterViewModifier(router: self,content: sheetContent)
    }
   
}



