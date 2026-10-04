import SwiftUI

extension SheetRouter {
    /// Creates a standalone sheet presenter for this router using typed destination views.
    /// - Parameter makeView: Builds the view for each route on the main actor.
    public func view<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> SheetRouterView<T, V> {
        SheetRouterView(router: self, makeView: makeView)
    }
}
