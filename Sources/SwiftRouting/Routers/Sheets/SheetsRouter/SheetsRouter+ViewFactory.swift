import SwiftUI

extension SheetsRouter {
    /// Creates a standalone nested sheet presenter for this router using typed destination views.
    /// - Parameter makeView: Builds the view for each route on the main actor.
    public func view<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> SheetsRouterView<T, V> {
        SheetsRouterView(router: self, makeView: makeView)
    }
}
