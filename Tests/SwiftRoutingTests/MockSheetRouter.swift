@testable import SwiftRouting
import Combine

enum TestRoute: Route { case first, second }
let mockRoutable = TestRoute.first
let mockRoutable2 = TestRoute.second

struct MockSheetsRouterFactory: SheetsRouterFactory {
    func instanceOfSheet() -> SheetRouter<TestRoute> { MockSheetRouter() }
}

@MainActor
class MockSheetRouter: SheetRouter<TestRoute> {
    var proxy: SheetRouter<TestRoute> { self }
    private var subscriptions: Set<AnyCancellable> = []

    override init() {
        super.init()
        $fullRoutable.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in self?.dismissFullScreen() }
            }
        }.store(in: &subscriptions)
        $partialRoutable.dropFirst().sink { [weak self] value in
            if value == nil {
                Task { @MainActor in self?.dismissPartialScreen() }
            }
        }.store(in: &subscriptions)
    }
}
