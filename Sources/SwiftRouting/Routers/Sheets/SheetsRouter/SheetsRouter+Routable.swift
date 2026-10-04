import SwiftUI

extension SheetsRouter {
    public func createView<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> SheetsRouterView<T, V> {
        SheetsRouterView(router: self, makeView: makeView)
    }
}
