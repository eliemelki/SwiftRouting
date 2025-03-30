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
    
    private func _hide(_ sheet: Sheet, animated: Bool) async {
        print("hide")
        await sheet.hide(animated: animated)
    }
    
    private func _hide(animated: Bool = true) async {
        await self._hide(index: self.sheets.count - 1, animated: animated)
    }
    
    private func _hide(index: Int, animated: Bool = true) async {
        let sheets = sheets
//        await self.hide(sheets[index])
        
        guard index >= 0 else { return }
        
        await withTaskGroup(of: Void.self) {  group in
      
            for i in (index..<sheets.count).reversed() {
                let clousure: @MainActor () async -> Void = {
                    await self._hide(sheets[i], animated: animated)
                }
                group.addTask {
                     await clousure()
                }
            }

            for await _ in group {}
        }
    }
    
    @discardableResult
    private func _show<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable {
        print("show")
        let currentSheet = self.placeholderSheet
        
        let placeHolderSheet: Sheet = self.factory.instanceOfSheet()
        self.placeholderSheet = placeHolderSheet
        
        
        let dismissHandler = { [weak self] in
            guard let self else { return }
            onSheetDismiss(currentSheet, onDismiss: onDismiss)
        }
        
        self.sheets.append(currentSheet)
        
        
        return await currentSheet.show(item, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        
    }
}

extension SheetsRouter: SheetsCoordinator {
    
    @discardableResult
    public func show<T: Routable>(_ item: T,  sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable? {
        return await queue.execute { @MainActor [weak self] in
            return await self?._show(item, sheetType:sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    @discardableResult
    public func replace<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool = true, onDismiss: SheetDismissHandler?) async -> AnyRoutable? {
        return await queue.execute { [weak self] in
            await self?._hide(animated: animated)
            return await self?._show(item, sheetType:sheetType, animated: animated, onDismiss: onDismiss)
        }
    }
    
    public func hide(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(animated: animated)
        }
    }
    
    public func hideAll(animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(index: 0, animated: animated)
        }
    }
    
  
    public func hide(index: Int, animated: Bool = true) async {
        await queue.execute { [weak self] in
            await self?._hide(index: index, animated: animated)
        }
    }
    public func hide(routable: AnyRoutable,animated: Bool = true) async {
        await queue.execute { [weak self] in
            let index = self?.sheets.firstIndex { $0.isDisplaying(routable) }
            guard let index else {
                return
            }
            await self?._hide(index: index, animated: animated)
        }
    }
}


