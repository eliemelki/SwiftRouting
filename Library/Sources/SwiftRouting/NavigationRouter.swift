//
//  NavigationRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 06/03/2025.
//

import SwiftUI
import Combine

@MainActor
public protocol NavigationCoordinator {
    
    func setMainViewFactory<T: Routable>(_ factory: T)
    
    func push<T: Routable>(_ factory: T)
    
    func popLast()
    
    func popToRoot()
}

open class NavigationRouter: ObservableObject {
    
    @Published fileprivate var paths: NavigationPath
    @Published fileprivate var mainViewFactory: AnyRoutable?
    
    public init(paths: NavigationPath = NavigationPath()) {
        self.paths = paths
    }
  
    deinit {
        print("\(self)-\(Unmanaged.passUnretained(self).toOpaque()) deinit")
    }
}

extension NavigationRouter : NavigationCoordinator {
    public  func setMainViewFactory<T: Routable>(_ factory: T) {
        mainViewFactory = AnyRoutable(factory)
    }
    
    public func push<T: Routable>(_ factory: T) {
        paths.append(AnyRoutable(factory))
    }
    
    public func popLast() {
        paths.removeLast()
    }
    
    public func popToRoot() {
        paths.removeLast(self.paths.count)
    }
}


public struct NavigationRouterView: View {
    
    @ObservedObject var router: NavigationRouter
    
    public init(router: NavigationRouter) {
        _router = ObservedObject(wrappedValue: router)
    }
    
    public var body: some View {
        NavigationStack(path: $router.paths) {
            router.mainViewFactory?.createView()
                .navigationDestination(for: AnyRoutable.self) { router in
                    router.createView()
                }
        }
    }
}
