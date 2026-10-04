//
//  Animation.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//

import SwiftUI

extension ObservableObject {
    func runWithAnimation(animated: Bool, callback: () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = !animated
        withTransaction(transaction, callback)
    }
}
