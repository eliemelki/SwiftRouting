//
//  SheetRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI


enum SheetRoutable: String, Route {

    case sheet1, sheet2

    @ViewBuilder
    func createView(coordinator: SheetCoordinator) -> some View {
        switch self {
        case .sheet1:
            SheetView1(coordinator: coordinator)
        case .sheet2:
            SheetView2(coordinator: coordinator)
        }
    }
}

@MainActor
class SheetCoordinator : ObservableObject {
    let sheetRouter = SheetRouter<SheetRoutable>()

    var value = 0

    func showSheet1() {
        sheetRouter.show(SheetRoutable.sheet1, sheetType: .partial, animated: false) {
            print("dismissed SheetView1")
        }
    }

    func hideSheet1() {
        value += 1
        //sheetRouter.hide(animated: value % 2 == 0)
        sheetRouter.hide()
    }

    func replaceSheet1BySheet2() {

        value += 1
//        sheetRouter.show(routable, sheetType: .fullScreen,animated: value % 2 == 0) {
//            print("dismiss SheetView2")
//        }
        sheetRouter.show(SheetRoutable.sheet2, sheetType: .fullScreen, animated: true) {
            print("dismiss SheetView2")
        }
    }

    func hideSheet2() {
        value += 1
        //sheetRouter.hide(animated: value % 2 == 0)
        sheetRouter.hide(animated: false)
    }
}

struct SheetDemoView : View {
    @StateObject var coordinator: SheetCoordinator = .init()

    var body: some View {
        VStack {
            SheetBase(coordinator: coordinator)
        }.sheetRouterView(coordinator.sheetRouter) { route in
            route.createView(coordinator: coordinator)
        }
    }
}

fileprivate struct SheetBase : View {
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

fileprivate struct SheetView1 : View {
    let coordinator: SheetCoordinator
    var body: some  View {
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

fileprivate struct SheetView2 : View {
    let coordinator: SheetCoordinator
    var body: some  View {
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

