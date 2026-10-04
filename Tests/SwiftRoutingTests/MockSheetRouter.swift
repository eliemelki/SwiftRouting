@testable import SwiftRouting
import Combine

enum TestRoute: Route { case first, second }
let firstRoute = TestRoute.first
let secondRoute = TestRoute.second

struct MockSheetsRouterFactory: SheetsRouterFactory {
    func makeSheetRouter() -> SheetRouter<TestRoute> { MockSheetRouter() }
}

@MainActor
class MockSheetRouter: SheetRouter<TestRoute> {
    private var subscriptions: Set<AnyCancellable> = []

    override init() {
        super.init()
        $fullScreenEntry.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in self?.didDismissFullScreen() }
            }
        }.store(in: &subscriptions)
        $partialEntry.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in self?.didDismissPartialSheet() }
            }
        }.store(in: &subscriptions)
    }
}
