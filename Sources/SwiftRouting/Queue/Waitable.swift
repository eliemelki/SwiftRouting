//
//  Waitable.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

protocol Waitable {
    func waitForCompletion() async
}

extension Task: Waitable {
    func waitForCompletion() async {
        _ = try? await value
    }
}
