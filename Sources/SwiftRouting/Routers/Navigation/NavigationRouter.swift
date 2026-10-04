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
@MainActor
public class NavigationRouter<T: Route>: ObservableObject, Sendable {
    
    @Published var paths: [RouteEntry<T>]
    @Published var main: T
    
    public init(main: T) {
        self.paths = []
        self.main = main
    }
}
