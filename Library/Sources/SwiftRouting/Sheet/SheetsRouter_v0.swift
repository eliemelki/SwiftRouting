////
////  SheetsRouter.swift
////  SwiftRouting
////
////  Created by Elie Melki on 14/03/2025.
////
//
//import SwiftUI
//
//@MainActor
//public protocol SheetItemCoordinator: AnyObject {
//    func hide()
//}
//extension SheetViewModel : SheetItemCoordinator {
//    
//}
//
//@MainActor
//public protocol SheetsCoordinator {
//    @discardableResult
//    func show<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHander?) -> SheetItemCoordinator
//    @discardableResult
//    func replace<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHander?) -> SheetItemCoordinator
//    func hide()
//    func hideAll()
//}
//
//@MainActor
//public struct SheetViewModelWrapper {
//    public let base: SheetViewModel
//    public let dismissHandler: SheetDismissHander?
//    
//    init(base: SheetViewModel, dismissHandler:SheetDismissHander?) {
//        self.base = base
//        self.dismissHandler = dismissHandler
//    }
//}
//
//@MainActor
//public class SheetsRouter: ObservableObject {
//   
//    @Published public private(set) var sheets: [SheetViewModelWrapper] = []
//    @Published public private(set) var placeholderSheet: SheetViewModel = .init()
//    
//    public init() {
//        
//    }
//}
//
//extension SheetsRouter: SheetsCoordinator {
//    
//    private func onSheetDismiss(_ index: Int) {
//       
//        guard index >= 0, index < sheets.count else {
//            return
//        }
//        
//        let sheet = self.sheets[index]
//        guard !sheet.base.hasSheetDisplayed() else {
//            return
//        }
//        
//        defer {
//            sheet.dismissHandler?()
//        }
//        
//        self.sheets = Array(self.sheets[0..<index])
//    }
//    
//    @discardableResult
//    public func show<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHander? = nil) -> SheetItemCoordinator {
//        
//        let currentSheet = self.placeholderSheet
//        
//        let placeHolderSheet: SheetViewModel = .init()
//        self.placeholderSheet = placeHolderSheet
//        
//        let index = self.sheets.count
//        let dismissHandler = { [weak self] in
//            guard let self else { return }
//            onSheetDismiss(index)
//        }
//        let currentSheetWrapper = SheetViewModelWrapper(base: currentSheet, dismissHandler: onDismiss)
//        self.sheets.append(currentSheetWrapper)
//        
//        if (isFullScreen) {
//            currentSheet.showFull(item, dismissHandler: dismissHandler)
//        }else {
//            currentSheet.showPartial(item, dismissHandler: dismissHandler)
//        }
//        return currentSheet
//    }
//    
//    public func replace<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHander?) -> SheetItemCoordinator {
//        self.hide()
//        show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
//        self.hide()
//        show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
//        return show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
//
//    }
//    
//    public func hide() {
//        guard let last = sheets.last else {
//            return
//        }
//        let dismissHandler = last.dismissHandler
//        Task { 
//            dismissHandler?()
//        }
//        sheets.removeLast()
//        placeholderSheet = .init()
//    }
//    
//    public func hideAll() {
//        sheets.removeAll() { _ in
//            hide()
//            return true
//        }
//    }
//    
//}
//
//public struct SheetsRouterView: View {
//    @ObservedObject var router: SheetsRouter
//    
//    public init(router: SheetsRouter) {
//        self.router = router
//    }
//    
//    public var body: some View {
//        VStack{}.buildSheetsFor(viewModels: router.sheets.map { $0.base } + [router.placeholderSheet])
//    }
//}
//
//extension View {
//    @ViewBuilder
//    func buildSheetsFor(viewModels: [SheetViewModel]) -> some View {
//        if !viewModels.isEmpty {
//            self.sheetFor(viewModels: viewModels)
//        } else {
//            self
//        }
//    }
//    
//    func sheetFor(viewModels: [SheetViewModel]) -> some View {
//        var viewModels = viewModels
//        let current = viewModels.removeFirst()
//        return SheetView(item: current) {
//            buildSheetsFor(viewModels: viewModels)
//        }
//    }
//}
