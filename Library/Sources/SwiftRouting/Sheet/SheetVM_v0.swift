////
////  SheetVM.swift
////  SwiftRouting
////
////  Created by Elie Melki on 14/03/2025.
////
//
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
//public class SheetViewModel : ObservableObject, Identifiable {
//    
//    @Published private(set) var fullPreviousDismissHandler: [SheetDismissHander] = []
//    @Published private(set) var partialPreviousDismissHandler:[SheetDismissHander] = []
//    
//    @Published fileprivate var fullRoutable: AnyRoutable?
//    @Published fileprivate var partialRoutable: AnyRoutable? { willSet {
//        print("here")
//    }}
//    
//    
//    public func hasSheetDisplayed() -> Bool {
//        return fullRoutable != nil || partialRoutable != nil
//    }
//}
//
//extension SheetViewModel {
//    
//    fileprivate func show<T: Routable>(_ routable:T,
//                                       previousDissmissHandlers: [SheetDismissHander],
//                                       originalDismissHandler:  SheetDismissHander?)
//    -> (routable: AnyRoutable, handlers: [SheetDismissHander]) {
//        
//        let item = AnyRoutable(routable)
//        
//        var previousHandlers = previousDissmissHandlers
//        previousHandlers.append({ originalDismissHandler?() })
//        
//        return (routable: item,
//                handlers: previousHandlers)
//    }
//    
//    fileprivate func dismiss(routable: AnyRoutable?, handlers: [SheetDismissHander]) -> [SheetDismissHander] {
//        var handlers = handlers
//        guard routable == nil else {
//            guard handlers.count > 1 else {
//                return handlers
//            }
//            //Means we are being replaced
//            guard let lastHandler = handlers.last else {
//                return []
//            }
//            handlers.removeLast()
//            handlers.forEach {
//                $0()
//            }
//            return [lastHandler]
//        }
//        handlers.reversed().forEach {
//            $0()
//        }
//        return []
//        
//    }
//    
//    fileprivate func dismissFullScreen() {
//        self.fullPreviousDismissHandler = dismiss(routable: self.fullRoutable, handlers: self.fullPreviousDismissHandler)
//    }
//    
//    fileprivate func dismissPartialScreen() {
//        self.partialPreviousDismissHandler = dismiss(routable: self.partialRoutable, handlers: self.partialPreviousDismissHandler)
//    }
//}
//
//extension SheetViewModel: SheetCoordinator {
//    
//    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
//    @discardableResult
//    public func showPartial<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHander? = nil) -> AnyRoutable  {
//        if (self.fullRoutable != nil) {
//            print("Calling Partial while full sheet is present. Dismissing full Sheet.")
//            self.hideFull()
//        }
//        
//        let item = self.show(routable, previousDissmissHandlers: self.partialPreviousDismissHandler, originalDismissHandler: dismissHandler)
//        self.partialRoutable = item.routable
//        self.partialPreviousDismissHandler = item.handlers
//        return item.routable
//    }
//    //We dont allow to pop both FullScreen and Partial at the same time. iOS Default behaviour if fullsheet is present, partial sheet does not open until full sheet is closed. If partial sheet is opened and full sheet is required, The dismiss handler are not called properly
//    @discardableResult
//    public func showFull<T: Routable>(_ routable:T, dismissHandler:  SheetDismissHander? = nil) -> AnyRoutable  {
//        if (self.partialRoutable != nil) {
//            print("Calling Full while partial sheet is present. Dismissing partial Sheet.")
//            self.hidePartial()
//        }
//        let item = self.show(routable, previousDissmissHandlers: self.fullPreviousDismissHandler, originalDismissHandler: dismissHandler)
//        self.fullRoutable = item.routable
//        self.fullPreviousDismissHandler = item.handlers
//        return item.routable
//    }
//    
//    public func hideFull() {
//        self.fullRoutable = nil
//    }
//    
//    public func hidePartial() {
//        self.partialRoutable = nil
//    }
//    
//    public func hide() {
//        hideFull()
//        hidePartial()
//    }
//}
//
//
//public struct SheetView<Content: View> : View {
// 
//    
//    @ObservedObject var item: SheetViewModel
//    var content: () -> Content
//    
//    
//    init(item: SheetViewModel, content: @escaping () -> Content = { EmptyView() }) {
//        self.item = item
//        self.content = content
//    }
//    
//    public var body: some View {
//        VStack{
//            VStack{}
//                .fullScreenCover(item: $item.fullRoutable, onDismiss: self.item.dismissFullScreen) { routable in
//                    VStack {
//                        routable.createView()
//                        content()
//                    }
//                }
//            VStack{}
//                .sheet(item: $item.partialRoutable, onDismiss: self.item.dismissPartialScreen) { routable in
//                    VStack {
//                        routable.createView()
//                        content()
//                    }
//                }
//        }
//    }
//    
//    
//}
