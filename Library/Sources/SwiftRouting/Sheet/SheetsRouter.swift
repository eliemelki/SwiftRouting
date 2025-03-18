//
//  SheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

@MainActor
public protocol SheetsCoordinator {
 
    func show<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func replace<T: Routable>(_ item: T, isFullScreen: Bool, onDismiss: SheetDismissHandler?) async -> AnyRoutable?
    func hide() async
    func hideAll() async
}

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
        await queue.executeW {
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
        var result: AnyRoutable?
        await queue.executeW { [weak self] in
            result = await self?._show(item, isFullScreen:isFullScreen, onDismiss: onDismiss)
        }
        return result
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
        for sheet in sheets {
            await hide(sheet)
        }
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
