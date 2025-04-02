//
//  NavigationRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 06/03/2025.
//

import SwiftUI
import Combine


///Implements NavigationCoordinator and allow for pushing and poping views.
///It use internally Navigation stack and have a NavigationPath.
///Whenever push or pop is called the router add/remove the routable to the path allowing to add push/pop the view.
open class NavigationRouter: ObservableObject {
    
    @Published var paths: NavigationPath
    @Published var main: AnyRoutable?
    
    public init(paths: NavigationPath = NavigationPath()) {
        self.paths = paths
    }
  
    deinit {
        print("\(self)-\(Unmanaged.passUnretained(self).toOpaque()) deinit")
    }
}

extension NavigationRouter : NavigationCoordinator {
    public  func setMain<T: Routable>(_ routable: T) {
        main = AnyRoutable(routable)
    }
    
    public func push<T: Routable>(_ routable: T) {
        paths.append(AnyRoutable(routable))
    }
    
    public func popLast() {
        paths.removeLast()
    }
    
    public func popToRoot() {
        paths.removeLast(self.paths.count)
    }
}



