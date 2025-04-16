//
//  SheetRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI


public struct SheetRouterViewModifier<SheetContent: View> : ViewModifier {
    
    @ObservedObject var router: SheetRouter
    var sheetContent: (AnyRoutable) -> SheetContent
    
    init(router: SheetRouter, content: @escaping (AnyRoutable) -> SheetContent = { r in r.createView() }) {
        self.router = router
        self.sheetContent = content
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.fullRoutable, onDismiss: self.router.dismissFullScreen) { routable in
                sheetContent(routable)
            }.transaction {
                $0.disablesAnimations = !router.animated
            }
            .sheet(item: $router.partialRoutable, onDismiss: self.router.dismissPartialScreen) { routable in
                sheetContent(routable)
            }
            .transaction {
                $0.disablesAnimations = !router.animated
            }
    }
}


extension View {
    func sheetRouterView(_ router: SheetRouter) -> some View {
        modifier(SheetRouterViewModifier(router: router))
    }
}


public struct SheetRouterView<Content: View> : View {
    
    @ObservedObject var router: SheetRouter
    
    init(router: SheetRouter) {
        self.router = router
    }
    
    public var body: some View {
        VStack{}.sheetRouterView(router)
    }
}
