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
        dismiss(routable: self.fullRoutable, dismissHandler: self.fullDismissHandler)
    }
    
    func dismissPartialScreen() {
        dismiss(routable: self.partialRoutable, dismissHandler: self.partialDismissHandler)
    }
}
