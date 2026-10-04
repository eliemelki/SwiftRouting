import SwiftUI

extension TabRouter {
    /// Creates a tab view for this router using typed destination views.
    /// - Parameters:
    ///   - makeView: Builds each tab destination on the main actor.
    ///   - makeLabel: Builds the title and icon for each tab item.
    public func view<V: View, L: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V,
                                     @ViewBuilder makeLabel: @escaping @MainActor (T) -> L) -> TabRouterView<T, V, L> {
        TabRouterView(router: self, makeView: makeView, makeLabel: makeLabel)
    }
}
