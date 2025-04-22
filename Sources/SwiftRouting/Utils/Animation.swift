//
//  Animation.swift
//  SwiftRouting
//
//  Created by Elie Melki on 22/04/2025.
//

import SwiftUI

extension ObservableObject {
    func runWithAnimation(animated: Bool, callback: () -> Void) {
        if animated {
            callback()
        }else {
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                callback()
            }
        }
    }
}
