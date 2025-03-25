//
//  SheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

@MainActor
public class SheetsRouter: ObservableObject {
   
    @Published var sheets: [Sheet] = []
    @Published var placeholderSheet: Sheet
    public private(set) var queue: RoutingQueue = .init()
    let factory: SheetsRouterFactory
    
    public convenience init() {
        self.init(factory: DefaultSheetsRouterFactory())
    }
    
    init(factory: SheetsRouterFactory) {
        self.factory = factory
        self.placeholderSheet = factory.instanceOfSheet()
    }
}

extension SheetsRouter {
    private func onSheetDismiss(_ router: Sheet, onDismiss: SheetDismissHandler?) {
        defer {
            onDismiss?()
        }
        var sheets = self.sheets
        sheets.removeAll { $0 === router }
        self.sheets = sheets
        self.placeholderSheet = factory.instanceOfSheet()
    }
    
    private func hide(_ sheet: Sheet) async {
        await queue.execute { @MainActor in
            await sheet.hide()
        }
    }
    
    @discardableResult
    private func _show<T: Routable>(_ item: T, sheetType: SheetType = .partial, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable {
        
        let currentSheet = self.placeholderSheet
        
        let placeHolderSheet: Sheet = self.factory.instanceOfSheet()
        self.placeholderSheet = placeHolderSheet
        
        
        let dismissHandler = { [weak self] in
            guard let self else { return }
            onSheetDismiss(currentSheet, onDismiss: onDismiss)
        }
        
        self.sheets.append(currentSheet)
        
        
        return await currentSheet.show(item, sheetType: sheetType, dismissHandler: dismissHandler)
        
    }
}

extension SheetsRouter: SheetsCoordinator {
    
    @discardableResult
    public func show<T: Routable>(_ item: T,  sheetType: SheetType = .partial, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable? {
        return await queue.execute { @MainActor [weak self] in
            return await self?._show(item, sheetType:sheetType, onDismiss: onDismiss)
        }
    }
    
    @discardableResult
    public func replace<T: Routable>(_ item: T, sheetType: SheetType = .partial, onDismiss: SheetDismissHandler?) async -> AnyRoutable? {
        await self.hide()
        return await self.show(item, sheetType:sheetType, onDismiss: onDismiss)
    }
    
    public func hide() async {
        guard let last = sheets.last else {
            return
        }
        
        await self.hide(last)
    }
    
    public func hideAll() async {
        for sheet in self.sheets.reversed() {
            await hide(sheet)
        }
    }
    
    public func hide(index: Int) async {
        let sheets = self.sheets
        for i in index..<sheets.count {
            let sheet = sheets[i]
            await hide(sheet)
        }
    }
    
    public func hide(routable: AnyRoutable) async {
        let index = self.sheets.firstIndex { $0.isDisplaying(routable) }
        guard let index else {
            return
        }
        await hide(index: index)
    }
}


