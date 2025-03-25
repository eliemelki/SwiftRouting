//
//  MockSheetproxy.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//


@testable import SwiftRouting
import Combine
import SwiftUI

 struct MockSheetsRouterFactory : SheetsRouterFactory {
    func instanceOfSheet() -> Sheet {
        return MockSheetRouter()
    }
}

@MainActor
class MockSheetRouter: Sheet {
    
    let proxy = SheetRouter()
    var fullRoutableCancelable: AnyCancellable?
    var partialRoutableCancelable: AnyCancellable?
  
    init() {
        fullRoutableCancelable =
        proxy
            .$fullRoutable
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] value in
                if (value == nil) {
                    Task {
                        self?.proxy.dismissFullScreen()
                    }
                }
            }
        partialRoutableCancelable =
        proxy
            .$partialRoutable
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] value in
                if (value == nil) {
                    Task {
                        self?.proxy.dismissPartialScreen()
                    }
                }
            }
    }
    func isDisplaying(_ routable: SwiftRouting.AnyRoutable) -> Bool {
        return proxy.isDisplaying(routable)
    }
    
    @discardableResult
    func show<T: Routable>(_ routable:T, sheetType: SheetType = .partial, dismissHandler:  SheetDismissHandler? = nil) async -> AnyRoutable {
        await proxy.show(routable, sheetType: sheetType, dismissHandler: dismissHandler)
    }
   
    
    func hide() async {
        await proxy.hide()
    }
    
    public func hasSheetDisplayed() -> Bool {
        return proxy.hasSheetDisplayed()
    }
    
    func sheetType() -> SwiftRouting.SheetType? {
        proxy.sheetType()
    }
    
    func dismissFullScreen() {
        proxy.dismissFullScreen()
    }
    
    func dismissPartialScreen() {
        proxy.dismissPartialScreen()
    }
    
    func createView<T>(content: @escaping () -> T) -> SwiftRouting.SheetRouterView<T> where T : View {
        return proxy.createView(content: content)
    }
}
