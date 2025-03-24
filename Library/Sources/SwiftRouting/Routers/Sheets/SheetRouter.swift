//
//  SheetVM.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

//
//  SheetRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 13/03/2025.
//
import SwiftUI





public typealias SheetDismissHandler = () -> ()
@MainActor
public class SheetRouter : ObservableObject, Identifiable {
    
    @Published private(set) var fullPreviousDismissHandler: SheetDismissHandler?
    @Published private(set) var partialPreviousDismissHandler: SheetDismissHandler?
    
    @Published fileprivate(set) var fullRoutable: AnyRoutable? { didSet {
        if fullRoutable == nil {
            self.dismissFullScreen()
        }
    }
    }
    @Published fileprivate(set) var partialRoutable: AnyRoutable?
    
    @Published fileprivate var dismissHandlerCompletion: SheetDismissHandler?
    
    @Published fileprivate var pendingDismissHandlerCompletion: [SheetDismissHandler] = []
    
    fileprivate var queue: RoutingQueue = .init()
    
    public func hasSheetDisplayed() -> Bool {
        return fullRoutable != nil || partialRoutable != nil
    }
    
    public init() {
        
    }
}

extension SheetRouter {
    
    fileprivate func dismiss(routable: AnyRoutable?, dismissHandler: SheetDismissHandler?)  {
        defer {
            let handler = dismissHandlerCompletion
            dismissHandlerCompletion = nil
            handler?()
        }
        
        guard routable == nil else {
            return
        }
        
        dismissHandler?()
    }
    
    fileprivate func dismissFullScreen() {
        dismiss(routable: self.fullRoutable, dismissHandler: self.fullPreviousDismissHandler)
    }
    
    fileprivate func dismissPartialScreen() {
        dismiss(routable: self.partialRoutable, dismissHandler: self.partialPreviousDismissHandler)
    }
}

extension SheetRouter {
    
    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
    @discardableResult
    public func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await self.hide()
        self.partialRoutable = item
        self.partialPreviousDismissHandler = dismissHandler
        
        return item
    }
    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
    @discardableResult
    public func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await self.hide()
        self.fullRoutable = item
        self.fullPreviousDismissHandler = dismissHandler
        return item
    }
    
    
    public func hide() async {
        await queue.execute {
            await withCheckedContinuation { @MainActor continuation in
                self._hide() {
                    continuation.resume()
                }
            }
        }
    }
    
    private func _hide(completion: @escaping SheetDismissHandler) {
        
        guard self.fullRoutable != nil || self.partialRoutable != nil else {
            completion()
            return
        }
        
        self.partialRoutable = nil
        self.fullRoutable = nil
        self.dismissHandlerCompletion = {
            completion()
        }
    }
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
                }
            VStack{}
                .sheet(item: $router.partialRoutable, onDismiss: self.router.dismissPartialScreen) { routable in
                    VStack {
                        routable.createView()
                        content()
                    }
                }
        }
    }
    
    
}
