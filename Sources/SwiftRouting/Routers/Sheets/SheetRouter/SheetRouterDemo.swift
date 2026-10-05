//
//  SheetRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

private enum SheetDemoRoute: String, Route {

    case sheet1, sheet2

    @ViewBuilder
    func makeView(coordinator: SheetCoordinator) -> some View {
        switch self {
        case .sheet1:
            SheetView1(coordinator: coordinator)
        case .sheet2:
            SheetView2(coordinator: coordinator)
        }
    }
}

@MainActor
private class SheetCoordinator: ObservableObject {
    let sheetRouter = SheetRouter<SheetDemoRoute>()

    func showSheet1() {
        sheetRouter.show(SheetDemoRoute.sheet1, sheetType: .partial, animated: false) {
            print("dismissed SheetView1")
        }
    }

    func hideSheet1() {
        sheetRouter.hide()
    }

    func replaceSheet1BySheet2() {

        sheetRouter.show(.sheet2, sheetType: .fullScreen)
    }

    func hideSheet2() {
        sheetRouter.hide(animated: false)
    }
}

struct SheetDemoView: View {
    @StateObject private var coordinator: SheetCoordinator = .init()

    var body: some View {
        VStack {
            SheetBase(coordinator: coordinator)
        }.sheetRouterView(coordinator.sheetRouter) { route in
            route.makeView(coordinator: coordinator)
        }
    }
}

private struct SheetBase: View {
    let coordinator: SheetCoordinator
    var body: some View {
        VStack {
            Text("Base")
            Button("Show SheetView1") {
                coordinator.showSheet1()
            }
        }
    }
}

private struct SheetView1: View {
    let coordinator: SheetCoordinator
    var body: some View {
        VStack {
            Text("SheetView1")
            Button("Replace SheetView1 by SheetView2 Full") {
                coordinator.replaceSheet1BySheet2()
            }

            Button("hide SheetView1") {
                coordinator.hideSheet1()
            }
        }

    }
}

private struct SheetView2: View {
    let coordinator: SheetCoordinator
    var body: some View {
        VStack {
            Text("SheetView2")
            Button("hide SheetView2") {
                coordinator.hideSheet2()
            }
        }

    }
}

#Preview {
    SheetDemoView()
}
