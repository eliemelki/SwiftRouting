//
//  PageRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

/// Renders typed destinations as swipeable pages and synchronizes router selection.
public struct PageRouterView<T: Route, V: View>: View {
    @ObservedObject var router: PageRouter<T>
    private let makeView: @MainActor (T) -> V
    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode

    /// Creates a view using an externally owned router.
    /// - Parameters:
    ///   - router: The router to observe.
    ///   - indexDisplayMode: Controls page indicator visibility.
    ///   - makeView: Builds each destination on the main actor.
    public init(router: PageRouter<T>, indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
                @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.indexDisplayMode = indexDisplayMode
        self.makeView = makeView
    }

    public var body: some View {
        if !router.pages.isEmpty {
            TabView(selection: router.selectionBinding) {
                ForEach(router.pages) { entry in
                    makeView(entry.route)
                        .tag(Optional(entry))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: indexDisplayMode))
        }
    }
}
