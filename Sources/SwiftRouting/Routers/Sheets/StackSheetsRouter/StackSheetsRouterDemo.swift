//
//  StackSheetsRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI

private enum StackedSheetRoute: Route {
    case first, second, replacedSecond, third

    @MainActor @ViewBuilder
    func makeView(coordinator: StackSheetsCoordinator) -> some View {
        switch self {
        case .first: TestView1(coordinator: coordinator)
        case .second: TestView2(coordinator: coordinator)
        case .replacedSecond: TestView2Replaced(coordinator: coordinator)
        case .third: TestView3(coordinator: coordinator)
        }
    }
}

@MainActor
private class StackSheetsCoordinator: ObservableObject {
    let stackSheetsRouter = StackSheetsRouter<StackedSheetRoute>()
    var secondSheet: RouteEntry<StackedSheetRoute>?

    func showFirstSheet() {
        stackSheetsRouter.show(.first, animated: false) {
            print("dismiss First")
        }
    }

    func showSecondSheet() {
        Task {
            secondSheet = await stackSheetsRouter.show(.second) {
                print("dismiss Second")
            }
        }
    }

    func replaceSecondSheet() {
        Task {
            secondSheet = await stackSheetsRouter.replace(.replacedSecond) {
                print("dismiss second Replaced")
            }
        }
    }

    func showThirdSheet() {
        stackSheetsRouter.show(.third) {
            print("dismiss Third")
        }
    }

    func hideLast() {
        stackSheetsRouter.hide()
    }

    func backToFirst() {

        guard let secondSheet else {
            return
        }
        stackSheetsRouter.hide(entry: secondSheet)
    }

    func hide() {
        stackSheetsRouter.hideAll(animated: false)
    }
}

struct StackSheetsDemoView: View {
    @StateObject private var coordinator = StackSheetsCoordinator()

    var body: some View {
        VStack {
            TestView(coordinator: coordinator)
        }
        .stackSheetsRouterView(coordinator.stackSheetsRouter) { route in
            route.makeView(coordinator: coordinator)
        }
    }
}

private struct TestView: View {
    let coordinator: StackSheetsCoordinator
    var body: some View {
        VStack {
            Text("Base")
            Button("Show Sheet1") {
                coordinator.showFirstSheet()
            }

        }
    }
}

private struct TestView1: View {
    let coordinator: StackSheetsCoordinator
    var body: some View {
        VStack {
            Text("Sheet 1")
            Button("Show Sheet2") {
                coordinator.showSecondSheet()
            }
        }

    }
}

private struct TestView2: View {
    let coordinator: StackSheetsCoordinator
    var body: some View {
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

private struct TestView2Replaced: View {
    let coordinator: StackSheetsCoordinator
    var body: some View {
        VStack {
            Text("Sheet 2 Replaced")
            Button("Show Sheet3") {
                coordinator.showThirdSheet()
            }
        }

    }
}

private struct TestView3: View {
    let coordinator: StackSheetsCoordinator
    var body: some View {
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
    StackSheetsDemoView()
}
