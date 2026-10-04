import SwiftUI

@MainActor
protocol SheetsRouterFactory<T> {
    associatedtype T: Route
    func instanceOfSheet() -> SheetRouter<T>
}

struct DefaultSheetsRouterFactory<T: Route>: SheetsRouterFactory {
    func instanceOfSheet() -> SheetRouter<T> {
        SheetRouter<T>()
    }
}
