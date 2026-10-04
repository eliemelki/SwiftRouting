//
//  ObservableObject+.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//

import SwiftUI

extension ObservableObject {
    /// Runs updates in a transaction that disables animations when requested.
    /// When enabled, the caller or presentation system supplies the animation.
    func runWithAnimation(animated: Bool, callback: () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = !animated
        withTransaction(transaction, callback)
    }
}
