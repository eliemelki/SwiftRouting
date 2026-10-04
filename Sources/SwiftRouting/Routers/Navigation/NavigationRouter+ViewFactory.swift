import SwiftUI

extension NavigationRouter {

    /// Creates a navigation stack for this router using typed destination views.
    /// - Parameter makeView: Builds the view for each route on the main actor.
    public func view<V: View>(@ViewBuilder makeView: @escaping @MainActor (T) -> V) -> NavigationRouterView<T, V> {
        return NavigationRouterView<T,V>(router: self, makeView: makeView)
    }
}
