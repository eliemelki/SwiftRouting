//
//  SheetRouter+ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI


// MARK: - SheetRouter - View factory
extension SheetRouter {
    public func createView<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> SheetRouterView<T, V> {
        SheetRouterView(router: self, makeView: makeView)
    }
}
