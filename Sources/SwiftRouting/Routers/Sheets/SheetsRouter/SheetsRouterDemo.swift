//
//  SheetsRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI

enum StackedSheetRoute: Route {
    case first, second, replacedSecond, third

    @MainActor @ViewBuilder
    func makeView(coordinator: SheetsCoordinator) -> some View {
        switch self {
        case .first: TestView1(coordinator: coordinator)
        case .second: TestView2(coordinator: coordinator)
        case .replacedSecond: TestView2Replaced(coordinator: coordinator)
        case .third: TestView3(coordinator: coordinator)
        }
    }
}

@MainActor
class SheetsCoordinator: ObservableObject {
    let sheetsRouter = SheetsRouter<StackedSheetRoute>()
    var secondSheet: RouteEntry<StackedSheetRoute>?

    func showFirstSheet() {
        sheetsRouter.show(.first, animated: false) { print("dismiss First") }
    }

    func showSecondSheet() {
        Task {
            secondSheet = await sheetsRouter.show(.second) { print("dismiss Second") }
        }
    }

    func replaceSecondSheet() {
        Task {
            secondSheet = await sheetsRouter.replace(.replacedSecond) { print("dismiss second Replaced") }
        }
    }

    func showThirdSheet() {
        sheetsRouter.show(.third) { print("dismiss Third") }
    }

    func hideLast() {
        sheetsRouter.hide()
    }

    func backToFirst() {

        guard let secondSheet else { return }
        sheetsRouter.hide(entry: secondSheet)
    }

    func hide() {
        sheetsRouter.hideAll(animated: false)
    }
}

struct SheetsDemoView: View {
    @StateObject var coordinator = SheetsCoordinator()

    var body: some View {
        VStack {
            TestView(coordinator: coordinator)
        }
        .sheetsRouterView(coordinator.sheetsRouter) { route in
            route.makeView(coordinator: coordinator)
        }
    }
}

fileprivate struct TestView : View {
    let coordinator: SheetsCoordinator
    var body: some View {
        VStack {
            Text("Base")
            Button("Show Sheet1") {
                coordinator.showFirstSheet()
            }

        }
    }
}

fileprivate struct TestView1 : View {
    let coordinator: SheetsCoordinator
    var body: some  View {
        VStack {
            Text("Sheet 1")
            Button("Show Sheet2") {
                coordinator.showSecondSheet()
            }
        }

    }
}

fileprivate struct TestView2 : View {
    let coordinator: SheetsCoordinator
    var body: some  View {
        VStack {
            Text("Sheet 2")
            Button("Show Sheet3") {
                coordinator.showThirdSheet()
            }
            Button("Replace Sheet2") {
                coordinator.replaceSecondSheet()
            }
        }

    }
}

fileprivate struct TestView2Replaced : View {
    let coordinator: SheetsCoordinator
    var body: some  View {
        VStack {
            Text("Sheet 2 Replaced")
            Button("Show Sheet3") {
                coordinator.showThirdSheet()
            }
        }

    }
}

fileprivate struct TestView3 : View {
    let coordinator: SheetsCoordinator
    var body: some  View {
        VStack {
            Text("Sheet 3")
            Button("Dissmis All Sheet") {
                coordinator.hide()
            }
            Button("Dissmis Last Sheet") {
                coordinator.hideLast()
            }

            Button("Back to first") {
                coordinator.backToFirst()
            }
        }

    }
}

#Preview {
    SheetsDemoView()
}
