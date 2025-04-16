//
//  SheetsRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 14/03/2025.
//

import SwiftUI

///SheetsRouter allows  allow for show and hide as many sheets/view. SheetsRouter stack sheets on top of each other, without having to worry if an existing sheet is present or not. It also sycnrhonise all calls. In other words, if you try to call 2 sheets at the same time,It will present both sheets sequantially.
///Basicall it internally has Multiple SheetRouter.

@MainActor
public class SheetsRouter: ObservableObject {
    
    @Published var sheets: [Sheet] = []
    @Published var placeholderSheet: Sheet
    public private(set) var queue: SerialQueue = .init()
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
    
    func _hide(_ sheet: Sheet, animated: Bool) async {
       await sheet.hide(animated: animated)
    }
    
    func _hide(animated: Bool = true) async {
        await self._hide(index: self.sheets.count - 1, animated: animated)
    }
    
    func _hide(index: Int, animated: Bool = true) async {
        if Test.isRunningTests() {
            //Do We want to hide them one by one?! Thats why for now only run for unit test.
            guard index >= 0 else { return }
            
            await withTaskGroup(of: Void.self) {  group in
                
                for i in (index..<sheets.count).reversed() {
                    let clousure: @MainActor () async -> Void = {
                        await self._hide(self.sheets[i], animated: animated)
                    }
                    group.addTask {
                        await clousure()
                    }
                }
                
                for await _ in group {}
            }
        }else {
            let sheets = sheets
            await self._hide(sheets[index], animated: animated)
        }
    }
    
    @discardableResult
    
    func _show<T: Routable>(_ item: T, sheetType: SheetType = .partial, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> AnyRoutable {
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

