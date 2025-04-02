//
//  SheetVM.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

@MainActor
protocol SheetDismissable {
    func dismissFullScreen()
    func dismissPartialScreen()
}

typealias Sheet = SheetCoordinator & SheetDismissable & SheetCoordinatorHelpers & SheetRouterViewFactory & AnyObject


///Implements SheetCoordinator and allow for single show/hide a view
///Basicall it internally add a placeholder for a fullScreenCover and a sheet.
///SheetRouter allows only one sheet (regardless if its fullscreen or partial) at a time and it make sure all calls are synchronised. In other words, if you call show twice, the second call  will hide the existing and show the new one. The reason we synchronise is to avoid any UI issues and for proper dismiss handler calls. 
@MainActor
public class SheetRouter : ObservableObject {
    
    @Published private var fullDismissHandler: SheetDismissHandler?
    @Published private var partialDismissHandler: SheetDismissHandler?
    
    @Published private var dismissHandlerCompletion: SheetDismissHandler?
    
    @Published var fullRoutable: AnyRoutable?
    @Published var partialRoutable: AnyRoutable?
    
    @Published var animated: Bool = true
   
    private var queue: RoutingQueue = .init()
    
    public init() {
        
    }
}

extension SheetRouter {
    
    private func dismiss(routable: AnyRoutable?, dismissHandler: SheetDismissHandler?)  {
        defer {
            let handler = dismissHandlerCompletion
            fullDismissHandler = nil
            partialDismissHandler = nil
            dismissHandlerCompletion = nil
            handler?()
        }
        
        guard routable == nil else {
            return
        }
        
        dismissHandler?()
    }
    
    private func _hide() async {
        await withCheckedContinuation { @MainActor [weak self] continuation in
            self?._hide() {
                continuation.resume()
            }
        }
    }
    
    private func _hide( completion: @escaping SheetDismissHandler) {
        guard self.fullRoutable != nil || self.partialRoutable != nil else {
            completion()
            return
        }
        self.dismissHandlerCompletion = {
            completion()
        }
      
        self.partialRoutable = nil
        self.fullRoutable = nil
    }
    
    @discardableResult
    private func showPartial<T: Routable>(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await queue.execute {
            self.animated = animated
            await self._hide()
            self.partialRoutable = item
            self.partialDismissHandler = dismissHandler
        }
        return item
    }
  
    @discardableResult
    private func showFull<T: Routable>(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await queue.execute {
            self.animated = animated
            await self._hide()
            self.fullRoutable = item
            self.fullDismissHandler = dismissHandler
        }
        return item
    }
}

extension SheetRouter: SheetDismissable {
    public func dismissFullScreen() {
        dismiss(routable: self.fullRoutable, dismissHandler: self.fullDismissHandler)
    }
    
    public func dismissPartialScreen() {
        dismiss(routable: self.partialRoutable, dismissHandler: self.partialDismissHandler)
    }
}

extension SheetRouter : SheetRouterViewFactory {
    public func  createView() -> SheetRouterView<EmptyView> {
        return SheetRouterView(router: self, content: { EmptyView() })
    }
    
    func createView<T>(content: @escaping () -> T) -> SheetRouterView<T> where T : View {
        return SheetRouterView(router: self, content: content)
    }
}

extension SheetRouter: SheetCoordinator {
    
    public func hide(animated: Bool) async {
        await queue.execute { @MainActor [weak self] in
            self?.animated = animated
            await self?._hide()
        }
    }
   
    @discardableResult
    public func show<T: Routable>(_ routable:T, sheetType: SheetType, animated: Bool = true, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable {
        switch sheetType {
        case .fullScreen:
            await self.showFull(routable, animated: animated, dismissHandler: dismissHandler)
        case .partial:
            await self.showPartial(routable, animated: animated, dismissHandler: dismissHandler)
        }
    }
}

extension SheetRouter : SheetCoordinatorHelpers {
    public func hasSheetDisplayed() -> Bool {
        return fullRoutable != nil || partialRoutable != nil
    }
    
    public func isDisplaying(_ routable: AnyRoutable) -> Bool {
        return fullRoutable === routable || partialRoutable === routable
    }
    
    
    public func sheetType() -> SheetType? {
        if fullRoutable != nil {
            return .fullScreen
        } else if partialRoutable != nil {
            return .partial
        }
        return nil
    }
}
