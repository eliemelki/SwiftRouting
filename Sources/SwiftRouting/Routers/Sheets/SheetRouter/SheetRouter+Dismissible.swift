//
//  SheetRouter+Dismissible.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

extension SheetRouter {
    /// Handles SwiftUI completing a full-screen dismissal.
    func didDismissFullScreen() {
        finishDismissal(entry: self.fullScreenEntry, sheetType: .fullScreen, onDismiss: self.onFullScreenDismiss)
    }

    /// Handles SwiftUI completing a partial-sheet dismissal.
    func didDismissPartialSheet() {
        finishDismissal(entry: self.partialEntry, sheetType: .partial, onDismiss: self.onPartialDismiss)
    }
}
