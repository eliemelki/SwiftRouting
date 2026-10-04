//
//  SheetRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI


public struct SheetRouterViewModifier<T: Route, V: View> : ViewModifier {
    
    @ObservedObject var router: SheetRouter<T>
    private let makeView: @MainActor (T) -> V
    
    public init(router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.fullRoutable, onDismiss: self.router.dismissFullScreen) { entry in
                makeView(entry.route)
            }.sheet(item: $router.partialRoutable, onDismiss: self.router.dismissPartialScreen) { entry in
                makeView(entry.route)
            }
    }
}


public extension View {
    func sheetRouterView<T: Route, V: View>(_ router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) -> some View {
        modifier(SheetRouterViewModifier(router: router, makeView: makeView))
    }
}

public struct SheetRouterView<T: Route, V: View> : View {
    
    @ObservedObject var router: SheetRouter<T>
    private let makeView: @MainActor (T) -> V
    
    public init(router: SheetRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }
    
    public var body: some View {
        VStack{}.sheetRouterView(router, makeView: makeView)
    }
}
