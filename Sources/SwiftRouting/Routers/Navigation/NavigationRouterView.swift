//
//  NavigationRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//
import SwiftUI

public struct NavigationRouterView: View {
    
    @ObservedObject var router: NavigationRouter
    
    init(router: NavigationRouter) {
        _router = ObservedObject(wrappedValue: router)
    }
    
    public var body: some View {
        NavigationStack(path: $router.paths) {
            router.main?.createView()
                .navigationDestination(for: AnyRoutable.self) { router in
                    router.createView()
                }
        }
    }
}
