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
public class SheetsRouter<T: Route>: ObservableObject {
    
    @Published var sheets: [SheetRouter<T>] = []
    @Published var placeholderSheet: SheetRouter<T>
    public private(set) var queue: SerialQueue = .init()
    let factory: any SheetsRouterFactory<T>
    
    public convenience init() {
        self.init(factory: DefaultSheetsRouterFactory<T>())
    }
    
    init(factory: any SheetsRouterFactory<T>) {
        self.factory = factory
        self.placeholderSheet = factory.instanceOfSheet()
    }
}

extension SheetsRouter {
    private func onSheetDismiss(_ router: SheetRouter<T>, onDismiss: SheetDismissHandler?) {
        defer {
            onDismiss?()
        }
        var sheets = self.sheets
        sheets.removeAll { $0 === router }
        self.sheets = sheets
        self.placeholderSheet = factory.instanceOfSheet()
    }
    
    func _hide(_ sheet: SheetRouter<T>, animated: Bool) async {
       await sheet.hide(animated: animated)
    }
    
    func _hide(animated: Bool = true) async {
        await self._hide(index: self.sheets.count - 1, animated: animated)
    }
    
    func _hide(index: Int, animated: Bool = true) async {
        guard sheets.indices.contains(index) else { return }
        
        // Snapshot before awaiting: dismissal callbacks mutate the live array.
        let sheets = Array(self.sheets[index...])
        for sheet in sheets.reversed() {
            await self._hide(sheet, animated: animated)
        }
    }
    
    @discardableResult
    
    func _show(_ item: T, sheetType: SheetType = .partial, animated: Bool, onDismiss: SheetDismissHandler? = nil) async -> RouteEntry<T> {
        let currentSheet = self.placeholderSheet
        
        let placeHolderSheet: SheetRouter<T> = self.factory.instanceOfSheet()
        self.placeholderSheet = placeHolderSheet
        
        
        let dismissHandler = { [weak self, weak currentSheet] in
            guard let self, let currentSheet else { return }
            onSheetDismiss(currentSheet, onDismiss: onDismiss)
        }
        
        self.sheets.append(currentSheet)
        
        
        return await currentSheet.show(item, sheetType: sheetType, animated: animated, dismissHandler: dismissHandler)
        
    }
}

