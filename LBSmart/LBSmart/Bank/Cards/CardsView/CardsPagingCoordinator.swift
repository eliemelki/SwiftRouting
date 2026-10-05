//
//  CardsPagingCoordinator.swift
//  LBSmart
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting

/// The coordinator capabilities required by this screen.
@MainActor
protocol CardsPagingCoordinator: AnyObject {
    associatedtype CardContent: View
    var pageRouter: PageRouter<BankCard> { get }
    func makeCardView(for card: BankCard) -> CardContent
}
