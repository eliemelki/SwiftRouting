//
//  SheetRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI

@MainActor
protocol SheetRouterViewFactory  {
    func createView<T>(content: @escaping () -> T) -> SheetRouterView<T> where T: View
}

public struct SheetRouterView<Content: View> : View {
    
    @ObservedObject var router: SheetRouter
    var content: () -> Content
    
    
    public init(router: SheetRouter, content: @escaping () -> Content = { EmptyView() }) {
        self.router = router
        self.content = content
    }
    
    public var body: some View {
        VStack{
            VStack{}
                .fullScreenCover(item: $router.fullRoutable, onDismiss: self.router.dismissFullScreen) { routable in
                    VStack {
                        routable.createView()
                        content()
                    }
                }.transaction {
                    $0.disablesAnimations = !router.animated
                }
            VStack{}
                .sheet(item: $router.partialRoutable, onDismiss: self.router.dismissPartialScreen) { routable in
                    VStack {
                        routable.createView()
                        content()
                    }
                }
                .transaction {
                    $0.disablesAnimations = !router.animated
                }
        }
    }
}
