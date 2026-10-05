//
//  StackSheetsRouterFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Creates single-sheet presenters for a typed presentation stack.
@MainActor
protocol StackSheetsRouterFactory<T> {
    /// The route type supported by every presenter.
    associatedtype T: Route
    /// Creates an empty presenter with independent dismissal state.
    func makeSheetRouter() -> SheetRouter<T>
}

struct DefaultStackSheetsRouterFactory<T: Route>: StackSheetsRouterFactory {
    func makeSheetRouter() -> SheetRouter<T> {
        SheetRouter<T>()
    }
}
