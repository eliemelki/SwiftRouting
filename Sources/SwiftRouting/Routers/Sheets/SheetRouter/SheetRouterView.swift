//
//  SheetRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI


public struct SheetRouterViewModifier : ViewModifier {
    
    @ObservedObject var router: SheetRouter
    
    init(router: SheetRouter) {
        self.router = router
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.fullRoutable, onDismiss: self.router.dismissFullScreen) { routable in
                routable.createView()
            }.sheet(item: $router.partialRoutable, onDismiss: self.router.dismissPartialScreen) { routable in
                routable.createView()
            }
    }
}


extension View {
    func sheetRouterView(_ router: SheetRouter) -> some View {
        modifier(SheetRouterViewModifier(router: router))
    }
}

public struct SheetRouterView : View {
    
    @ObservedObject var router: SheetRouter
    
    init(router: SheetRouter) {
        self.router = router
    }
    
    public var body: some View {
        VStack{}.sheetRouterView(router)
    }
}
