//
//  SheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI



@MainActor
public class SheetsRouter: ObservableObject {
   
    @Published public private(set) var sheets: [SheetRouter] = []
    @Published public private(set) var placeholderSheet: SheetRouter = .init()
    public private(set) var queue: RoutingQueue = .init()
    
    public init() {
    }
}

extension SheetsRouter {
    private func onSheetDismiss(_ router: SheetRouter, onDismiss: SheetDismissHandler?) {
        defer {
            onDismiss?()
        }
        var sheets = self.sheets
        sheets.removeAll { $0 === router }
        self.sheets = sheets
        self.placeholderSheet = .init()
    }
    
    private func hide(_ sheet: SheetRouter) async {
        await queue.execute { @MainActor in
            await sheet.hide()
        }
    }
    
    @discardableResult
    private func _show<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable {

        let currentSheet = self.placeholderSheet
        
        let placeHolderSheet: SheetRouter = .init()
        self.placeholderSheet = placeHolderSheet
        

        let dismissHandler = { [weak self] in
            guard let self else { return }
            onSheetDismiss(currentSheet, onDismiss: onDismiss)
        }
    
        self.sheets.append(currentSheet)
        
        if (isFullScreen) {
            return await currentSheet.showFull(item, dismissHandler: dismissHandler)
        }else {
            return await currentSheet.showPartial(item, dismissHandler: dismissHandler)
        }
    }
}

extension SheetsRouter: SheetsCoordinator {
    
    public func show<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable? {
        return await queue.execute { @MainActor [weak self] in
            return await self?._show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
        }
    }
    
    public func replace<T: Routable>(_ item: T, isFullScreen: Bool = false, onDismiss: SheetDismissHandler?) async -> AnyRoutable? {
        await self.hide()
        return await self.show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
    }
    
    public func hide() async {
        guard let last = sheets.last else {
            return
        }
        
        await self.hide(last)
    }
    
    public func hideAll() async {
        guard let sheet = sheets.first else {
            return
        }
        await hide(sheet)
    }
    
    public func hide(index: Int) async {
        guard index >= 0, index < self.sheets.count else {
            return
        }
        
        let sheet = sheets[index]
        await hide(sheet)
    }
    
    public func hide(router: AnyRoutable) async {
        let index = self.sheets.firstIndex { $0.fullRoutable === router || $0.partialRoutable === router }
        guard let index = index else {
            return
        }
        await hide(index: index)
    }
}

public struct SheetsRouterView: View {
    @ObservedObject var router: SheetsRouter
    
    public init(router: SheetsRouter) {
        self.router = router
    }
    
    public var body: some View {
        VStack{}.buildSheetsFor(viewModels: router.sheets + [router.placeholderSheet])
    }
}

extension View {
    @ViewBuilder
    func buildSheetsFor(viewModels: [SheetRouter]) -> some View {
        if !viewModels.isEmpty {
            self.sheetFor(viewModels: viewModels)
        } else {
            self
        }
    }
    
    func sheetFor(viewModels: [SheetRouter]) -> some View {
        var viewModels = viewModels
        let current = viewModels.removeFirst()
        return SheetRouterView(router: current) {
            buildSheetsFor(viewModels: viewModels)
        }
    }
}
