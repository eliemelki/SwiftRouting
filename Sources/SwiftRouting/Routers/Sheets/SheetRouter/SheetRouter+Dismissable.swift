//
//  SheetRouter+Dismissable.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//


// MARK: - SheetDismissable

@MainActor
protocol SheetDismissable {
    func dismissFullScreen()
    func dismissPartialScreen()
}

// MARK: - SheetRouter - SheetDismissable

extension SheetRouter: SheetDismissable {
    func dismissFullScreen() {
        dismiss(route: self.fullRoutable, sheetType: .fullScreen, dismissHandler: self.fullDismissHandler)
    }
    
    func dismissPartialScreen() {
        dismiss(route: self.partialRoutable, sheetType: .partial, dismissHandler: self.partialDismissHandler)
    }
}
