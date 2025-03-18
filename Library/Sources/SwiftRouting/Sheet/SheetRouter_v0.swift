////
////  SheetRouter.swift
////  SwiftRouting
////
////  Created by Elie Melki on 06/03/2025.
////
//
//
//import SwiftUI
//import Combine
//
//@MainActor
//public protocol SheetCoordinator {
//    @discardableResult
//    func showFull<T: Routable>(_ routable:T, dismissHandler: SheetDismissHander?) -> AnyRoutable
//    @discardableResult
//    func showPartial<T: Routable>(_ routable:T, dismissHandler: SheetDismissHander?) -> AnyRoutable
//    func hideFull()
//    func hidePartial()
//    func hide()
//}
//
//@MainActor
//public class SheetRouter: ObservableObject {
//    
//    @Published public fileprivate(set) var item: SheetViewModel = .init()
//    
//    public init() { }
//    deinit {
//        print("\(self)-\(Unmanaged.passUnretained(self).toOpaque()) deinit")
//    }
//    
//   
//}
//
//extension SheetRouter: SheetCoordinator {
//    
//    @discardableResult
//    public func showFull<T: Routable>(_ routable:T, dismissHandler: SheetDismissHander? = nil) -> AnyRoutable {
//        return item.showFull(routable, dismissHandler: dismissHandler)
//    }
//    @discardableResult
//    public func showPartial<T: Routable>(_ routable:T, dismissHandler: SheetDismissHander? = nil) -> AnyRoutable {
//        return item.showPartial(routable, dismissHandler: dismissHandler)
//    }
//    public func hideFull() {
//        return item.hideFull()
//    }
//    public func hidePartial() {
//        return item.hidePartial()
//    }
//    public func hide() {
//        return item.hide()
//    }
//}
//
//
//public struct SheetRouterView: View {
//    
//    @ObservedObject var router: SheetRouter
//    
//    public init(router: SheetRouter) {
//        _router = ObservedObject(wrappedValue: router)
//    }
//    
//    public var body: some View {
//        SheetView(item: router.item)
//    }
//}
//
//
//
