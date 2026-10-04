//
//  NavigationRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI

public struct NavigationRouterView<T : Route, V: View>: View {
    
    @ObservedObject var router: NavigationRouter<T>
    private let makeView: @MainActor (T) -> V
    
    init(router: NavigationRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self._router = ObservedObject(wrappedValue: router)
        self.makeView = makeView
    }
    
    public var body: some View {
        NavigationStack(path: $router.paths) {
            makeView(router.main)
                .navigationDestination(for: RouteEntry<T>.self) { entry in
                    makeView(entry.route)
                }
        }
    }
}
