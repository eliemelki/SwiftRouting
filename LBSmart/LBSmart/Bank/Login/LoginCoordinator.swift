//
//  LoginCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import Foundation

/// The coordinator capabilities required by this screen.
@MainActor
protocol LoginCoordinator: AnyObject {
    func signIn()
}
