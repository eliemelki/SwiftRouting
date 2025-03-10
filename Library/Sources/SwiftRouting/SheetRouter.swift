//
//  SheetRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 06/03/2025.
//


import SwiftUI
import Combine

@MainActor
public protocol SheetCoordinator {
    func show<T: Routable>(_ item: T)
    func hide()
}

public class SheetRouter: ObservableObject {
    
    @Published public fileprivate(set) var item: AnyRoutable? = nil
    
    
    public init() {
        
    }
    deinit {
        print("\(self)-\(Unmanaged.passUnretained(self).toOpaque()) deinit")
    }
}

extension SheetRouter: SheetCoordinator {
    public func show<T: Routable>(_ item: T) {
        self.item = AnyRoutable(item)
    }
    
    public func showFullScreen<T: Routable>(_ item: T) {
        
    }
    
    public func hide() {
        self.item = nil
    }
}


public struct SheetRouterView: View {
    
    @StateObject var router: SheetRouter
    
    public init(router: SheetRouter) {
        _router = StateObject(wrappedValue: router)
    }
    
    public var body: some View {
        VStack{}.sheet(item: $router.item, content: { item in
            item.createView()
        })
    }
}
