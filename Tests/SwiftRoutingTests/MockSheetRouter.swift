//
//  MockSheetRouter.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import Combine

@testable import SwiftRouting

enum TestRoute: Route {
    case first, second
}
let firstRoute = TestRoute.first
let secondRoute = TestRoute.second

struct MockStackSheetsRouterFactory: StackSheetsRouterFactory {
    func makeSheetRouter() -> SheetRouter<TestRoute> {
        MockSheetRouter()
    }
}

@MainActor
class MockSheetRouter: SheetRouter<TestRoute> {
    private var subscriptions: Set<AnyCancellable> = []

    override init() {
        super.init()
        $fullScreenEntry.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in
                    self?.didDismissFullScreen()
                }
            }
        }.store(in: &subscriptions)
        $partialEntry.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in
                    self?.didDismissPartialSheet()
                }
            }
        }.store(in: &subscriptions)
    }
}
