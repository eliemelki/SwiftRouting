//
//  SheetsFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//

import Combine
import SwiftUI

typealias Sheet = SheetActions & SheetDismissable & SheetViewFactory & AnyObject


@MainActor
protocol SheetsRouterFactory {
    func instanceOfSheet() -> Sheet
}

struct DefaultSheetsRouterFactory: SheetsRouterFactory {
    func instanceOfSheet() -> Sheet {
        return SheetRouter()
    }
}


// MARK: - SheetViewFactory

@MainActor
protocol SheetViewFactory  {
    func createView<T>(sheetContent: @escaping (AnyRoutable) -> T) -> NestedSheetRouterViewModifier<T>
}

extension SheetRouter : SheetViewFactory {
    func createView<T>(sheetContent: @escaping (AnyRoutable) -> T) -> NestedSheetRouterViewModifier<T> {
        NestedSheetRouterViewModifier(router: self,content: sheetContent)
    }
}
