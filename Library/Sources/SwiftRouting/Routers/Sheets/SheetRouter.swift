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

typealias Sheet = SheetCoordinator & SheetDismissable & SheetRouterViewFactory & AnyObject

public typealias SheetDismissHandler = () -> ()

@MainActor
public class SheetRouter : ObservableObject {
    
    @Published private var fullDismissHandler: SheetDismissHandler?
    @Published private var partialDismissHandler: SheetDismissHandler?
    
    @Published private var dismissHandlerCompletion: SheetDismissHandler?
    
    @Published var fullRoutable: AnyRoutable?
    @Published var partialRoutable: AnyRoutable?
    
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
    
    private func _hide(completion: @escaping SheetDismissHandler) {
        
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
    
    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
    @discardableResult
    public func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await self.hide()
        self.partialRoutable = item
        self.partialDismissHandler = dismissHandler
        
        return item
    }
    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
    @discardableResult
    public func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
        let item = AnyRoutable(routable)
        await self.hide()
        self.fullRoutable = item
        self.fullDismissHandler = dismissHandler
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
    
    public func hasSheetDisplayed() -> Bool {
        return fullRoutable != nil || partialRoutable != nil
    }
    
    public func isDisplaying(_ routable: AnyRoutable) -> Bool {
        return fullRoutable === routable || partialRoutable === routable
    }
    
    @discardableResult
    public func show<T: Routable>(_ routable:T, sheetType: SheetType, dismissHandler:  SheetDismissHandler?) async -> AnyRoutable {
        switch sheetType {
        case .fullScreen:
            await self.showFull(routable, dismissHandler: dismissHandler)
        case .partial:
            await self.showPartial(routable, dismissHandler: dismissHandler)
        }
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


