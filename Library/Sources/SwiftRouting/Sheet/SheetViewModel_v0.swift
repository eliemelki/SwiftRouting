////
////  SheetViewModel.swift
////  SwiftRouting
////
////  Created by Elie Melki on 13/03/2025.
////
//import SwiftUI
//
//public typealias SheetDismissHander = () -> ()
//
//@MainActor
//public class SheetViewModel : ObservableObject {
//    
//    @Published public fileprivate(set) var fullScreenRoutable: AnyRoutable?
//    @Published public fileprivate(set) var partialScreenRoutable: AnyRoutable?
//    public fileprivate(set) var fullScreenDismissHandler: SheetDismissHander?
//    public fileprivate(set) var partialScreenDismissHandler: SheetDismissHander?
//    
//    public func hasSheetDisplayed() -> Bool {
//        return fullScreenRoutable != nil || partialScreenRoutable != nil
//    }
//}
//
//extension SheetViewModel: SheetCoordinator {
//    @discardableResult
//    public func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHander? = nil) -> AnyRoutable  {
//        let item = AnyRoutable(routable)
//        self.fullScreenRoutable = item
//        self.fullScreenDismissHandler = dismissHandler
//        return item
//    }
//    
//    @discardableResult
//    public func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHander? = nil) -> AnyRoutable  {
//        let item = AnyRoutable(routable)
//      
//        self.partialScreenRoutable = item
//        self.partialScreenDismissHandler = dismissHandler
//        return item
//    }
//    
//    public func hideFull() {
//        self.fullScreenRoutable = nil
//        self.fullScreenDismissHandler = nil
//    }
//    
//    public func hidePartial() {
//        self.partialScreenRoutable = nil
//        self.partialScreenDismissHandler = nil
//    }
//    
//    public func hide() {
//        hideFull()
//        hidePartial()
//    }
//}
//
//public struct SheetView<Content: View> : View {
//    @ObservedObject var item: SheetViewModel
//    var content: () -> Content
//    
//    
//    init(item: SheetViewModel, content: @escaping () -> Content = { EmptyView() }) {
//        self.item = item
//        self.content = content
//    }
//    
//    
//    public var body: some View {
//        VStack{
//            VStack{}.fullScreenCover(item: $item.fullScreenRoutable, onDismiss: item.fullScreenDismissHandler) { routable in
//                VStack {
//                    routable.createView()
//                    content()
//                }
//            }
//            VStack{}.sheet(item: $item.partialScreenRoutable, onDismiss: item.partialScreenDismissHandler) { routable in
//                VStack {
//                    routable.createView()
//                    content()
//                }
//            }
//        }
//    }
//}
