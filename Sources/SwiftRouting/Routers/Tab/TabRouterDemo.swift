//
//  TabRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

private enum TabDemoRoute: Route { case home, settings }

@MainActor
private class TabCoordinator: ObservableObject {
    let tabRouter = TabRouter<TabDemoRoute>(tabs: [.home, .settings])

    func showSettings() { tabRouter.select(.settings) }
    func showHome() { tabRouter.select(.home) }

    @ViewBuilder
    func makeView(_ route: TabDemoRoute) -> some View {
        switch route {
        case .home:
            VStack {
                Text("Home")
                Button("Show settings", action: showSettings)
            }
        case .settings:
            VStack {
                Text("Settings")
                Button("Back to home", action: showHome)
            }
        }
    }
}

struct TabDemoView: View {
    @StateObject private var coordinator = TabCoordinator()

    var body: some View {
        coordinator.tabRouter.view { route in
            coordinator.makeView(route)
        } makeLabel: { route in
            switch route {
            case .home: Label("Home", systemImage: "house")
            case .settings: Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview { TabDemoView() }
