//
//  AccountsNavigationCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

/// The coordinator capabilities required by this screen.
@MainActor
protocol AccountsNavigationCoordinator: AnyObject {
    associatedtype Destination: View
    var navigationRouter: NavigationRouter<AccountsRoute> { get }
    @ViewBuilder func makeView(for route: AccountsRoute) -> Destination
}
