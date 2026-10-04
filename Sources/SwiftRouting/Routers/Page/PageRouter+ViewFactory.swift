import SwiftUI

extension PageRouter {
    /// Creates a swipeable page view for this router using typed destination views.
    /// - Parameters:
    ///   - indexDisplayMode: Controls whether the page indicators are visible.
    ///   - makeView: Builds each page destination on the main actor.
    public func view<V: View>(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
                             @ViewBuilder makeView: @escaping @MainActor (T) -> V) -> PageRouterView<T, V> {
        PageRouterView(router: self, indexDisplayMode: indexDisplayMode, makeView: makeView)
    }
}
