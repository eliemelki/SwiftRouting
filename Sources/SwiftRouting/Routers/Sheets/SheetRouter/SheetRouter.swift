//
//  SheetVM.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

public typealias SheetDismissHandler = () -> ()


///SheetRouter allows only one sheet (regardless if its fullscreen or partial) at a time and it make sure all calls are synchronised. In other words, if you call show twice, the second call  will hide the existing and show the new one. The reason we synchronise is to avoid any UI issues and for proper dismiss handler calls.
///Basicall it internally add a placeholder for a fullScreenCover and a sheet.
///
@MainActor
public class SheetRouter<T: Route> : ObservableObject {
    
    var fullDismissHandler: SheetDismissHandler?
    var partialDismissHandler: SheetDismissHandler?
    
    private var dismissHandlerCompletion: SheetDismissHandler?
    
    @Published var fullRoutable: RouteEntry<T>?
    @Published var partialRoutable: RouteEntry<T>?
    
   
    private var activeSheetType: SheetType?

    var queue: SerialQueue = .init()
    
    public init() {
        
    }
}

extension SheetRouter {
    
    func dismiss(route: RouteEntry<T>?, sheetType: SheetType, dismissHandler: SheetDismissHandler?)  {
        guard activeSheetType == sheetType, route == nil else { return }
        let completion = dismissHandlerCompletion
        activeSheetType = nil
        fullDismissHandler = nil
        partialDismissHandler = nil
        dismissHandlerCompletion = nil
        dismissHandler?()
        completion?()
    }
    
    func _hide(animated: Bool) async {
        await withCheckedContinuation { @MainActor continuation in
            self._hide(animated: animated) {
                continuation.resume()
            }
        }
    }
    
    func _hide(animated: Bool, completion: @escaping SheetDismissHandler) {
        // A swipe clears the binding before onDismiss. Still wait for that callback.
        guard activeSheetType != nil else {
            completion()
            return
        }
        self.dismissHandlerCompletion = {
            completion()
        }
        
        runWithAnimation(animated: animated) {
            self.partialRoutable = nil
            self.fullRoutable = nil
        }
    }
    
    @discardableResult
    func showPartial(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> RouteEntry<T>  {
        let item = RouteEntry(routable)
        await queue.execute {
            await self._hide(animated: animated)
            self.runWithAnimation(animated: animated) {
                self.activeSheetType = .partial
                self.partialRoutable = item
                self.partialDismissHandler = dismissHandler
            }
        }
        return item
    }
  
    @discardableResult
    func showFull(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> RouteEntry<T>  {
        let item = RouteEntry(routable)
        await queue.execute {
            await self._hide(animated: animated)
            self.runWithAnimation(animated: animated) {
                self.activeSheetType = .fullScreen
                self.fullRoutable = item
                self.fullDismissHandler = dismissHandler
            }
        }
        return item
    }
    
}


