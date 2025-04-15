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
public class SheetRouter : ObservableObject {
    
    @Published var fullDismissHandler: SheetDismissHandler?
    @Published var partialDismissHandler: SheetDismissHandler?
    
    @Published private var dismissHandlerCompletion: SheetDismissHandler?
    
    @Published var fullRoutable: AnyRoutable?
    @Published var partialRoutable: AnyRoutable?
    
    @Published var animated: Bool = true
   
    var queue: SerialQueue = .init()
    
    public init() {
        
    }
}

extension SheetRouter {
    
    func dismiss(routable: AnyRoutable?, dismissHandler: SheetDismissHandler?)  {
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
    
    func _hide() async {
        await withCheckedContinuation { @MainActor [weak self] continuation in
            self?._hide() {
                continuation.resume()
            }
        }
    }
    
    func _hide( completion: @escaping SheetDismissHandler) {
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
    func showPartial<T: Routable>(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
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
    func showFull<T: Routable>(_ routable:T, animated: Bool, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable  {
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
