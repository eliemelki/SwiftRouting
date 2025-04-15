//
//  NavigationRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 06/03/2025.
//

import SwiftUI
import Combine

///Allow for pushing and poping views.
///It use internally Navigation stack and have a NavigationPath.
///Whenever push or pop is called the router add/remove the routable to the path allowing to add push/pop the view.
public class NavigationRouter: ObservableObject {
    
    @Published var paths: NavigationPath
    @Published var main: AnyRoutable?
    
    public init(paths: NavigationPath = NavigationPath()) {
        self.paths = paths
    }
}
