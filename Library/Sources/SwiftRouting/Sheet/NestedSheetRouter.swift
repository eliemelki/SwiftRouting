//////
////  NestedSheetRouter.swift
////  SwiftRouting
////
////  Created by Elie Melki on 13/03/2025.
////
//
//import SwiftUI
//
//@MainActor
//public protocol NestedSheetCoordinator {
//    @discardableResult
//    func show<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHander?) -> AnyRoutable?
//    @discardableResult
//    func replace<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHander?) -> AnyRoutable?
//    func hideLast()
//    func hide(item : AnyRoutable)
//    func hide()
//    
//}
//
//@MainActor
//public class NestedSheetRouter: ObservableObject {
//    
//    @Published public fileprivate(set) var items: [SheetViewModel] = [.init()]
//    
//    public init() { }
//    deinit {
//        print("\(self)-\(Unmanaged.passUnretained(self).toOpaque()) deinit")
//    }
//}
//
//extension NestedSheetRouter: NestedSheetCoordinator {
//    
//    private func onDismissed(_ viewModel: SheetViewModel, dissmissHandler: SheetDismissHander? = nil) {
//        defer {
//            dissmissHandler?()
//        }
//        
//        let index =  self.items.firstIndex { $0 === viewModel }
//        guard let index else {
//            return
//        }
//        let item = self.items[index]
//        guard !item.hasSheetDisplayed() else {
//            return
//        }
//        
//        self.items = Array(self.items[0..<index])
//        self.items.append(.init())
//    }
//    
//    //At minimum there always 1 Sheetitem. This always a placeholder for the one being added
//    @discardableResult
//    public func show<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHander? = nil) -> AnyRoutable? {
//        guard let currentViewModel = self.items.last else { return nil }
//        let placeHolderViewModel: SheetViewModel = .init()
//        self.items.append(placeHolderViewModel)
//        
//        let dismissHandler = { [weak self] in
//            guard let self else { return }
//            onDismissed(currentViewModel, dissmissHandler: onDismiss)
//        }
//        
//        if (isFullScreen) {
//            return currentViewModel.showFull(item, dismissHandler: dismissHandler)
//        }else {
//            return currentViewModel.showPartial(item, dismissHandler: dismissHandler)
//        }
//    }
//    
//    @discardableResult
//    public func replace<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHander? = nil) -> AnyRoutable? {
//        self.hideLast()
//        return self.show(item, isFullScreen: isFullScreen, onDismiss: onDismiss)
//    }
//    
//    public func hideLast() {
//        let lastIndex = self.items.count - 2
//        guard lastIndex >= 0 else {
//            return
//        }
//        self.items.removeLast(2)
//        self.items.append(.init())
//        let sheetVM = self.items[lastIndex]
//        sheetVM.hide()
//    }
//    
//    public func hide(item : AnyRoutable) {
//        let sheetVM:SheetViewModel? = nil// =  self.items.first {  $0.fullScreenRoutable == item || $0.partialScreenRoutable == item }
//        guard let sheetVM else {
//            return
//        }
//        
//        let index =  self.items.firstIndex { $0 === sheetVM }
//        guard let index else {
//            return
//        }
//        self.items = Array(self.items[0..<index])
//        self.items.append(.init())
//        sheetVM.hide()
//    }
//    
//    public func hide() {
//        let sheetVM =  self.items.first
//        guard let sheetVM else {
//            return
//        }
//        self.items = [.init()]
//        sheetVM.hide()
//    }
//    
//}
//
//public struct NestedSheetRouterView: View {
//    
//    @StateObject var router: NestedSheetRouter
//    
//    public init(router: NestedSheetRouter) {
//        _router = StateObject(wrappedValue: router)
//    }
//    
//    public var body: some View {
//        if (!router.items.isEmpty) {
//            VStack{}.nestedSheet(items: router.items)
//        } else {
//            EmptyView()
//        }
//    }
//}
//
//
//extension View {
//
//    func sheetFor(items: [SheetViewModel]) -> some View {
//        var items = items
//        let current = items.removeFirst()
//        return SheetView(item: current) {
//            nestedSheet(items: items)
//        }
//    }
//
//    @ViewBuilder
//    func nestedSheet(items: [SheetViewModel]) -> some View {
//        if !items.isEmpty {
//            self.sheetFor(items: items)
//        } else {
//            self
//        }
//    }
//}
//// 0 {SheetView} - > VStack {}.sheet(0) {  }
//// 1  VStack {}.sheet(0) { 0V VStack {}.sheet(1) { } }
//
//
//// 0 VStack{}
////VStack -> [1], 0 -> VStack {}.sheet(0) { 0V }
////VStack -> [0], X -> 0V
//
////VStack -> [2], 0 -> VStack {}.sheet(0) { 0V. }
////VStack -> [1], 1 -> VStack {}.sheet(1) { 1V }
////VStack -> [0], X -> 3V -> 1V
//
//
////VStack -> [1], 3 -> 3V { Sheet(3) { 3V }
////VStack -> [0], 3 -> 3V
//
////VStack {
////}.sheet(3) {
////    3V.sheet(2) {
////        2V.sheet(1) {
////            1V.sheet(0) {
////                0V
////            }
////        }
////    }
////}
//
////[4]
////VStack -> [4], 0 -> VStack { Sheet(0) { 0V }
////VStack -> [3], 1 -> 0V { Sheet(1) { 1V }
////VStack -> [2], 2 -> 1V { Sheet(2) { 2V }
////VStack -> [1], 3 -> 3V { Sheet(3) { 3V }
////VStack -> [0], x -> 3V
