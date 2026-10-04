import SwiftUI

enum NavigationRoute: Route {
    case main
    case first
    case second
}

@MainActor
class NavigationCoordinator: ObservableObject, MainCoordinator,
                             FirstCoordinator,
                             SecondCoordinator {

    let navigationRouter : NavigationRouter<NavigationRoute>

    init() {
        navigationRouter = NavigationRouter<NavigationRoute>(root: .main)
    }

    func pushFirst() {
        self.navigationRouter.push(.first, animated: false)
    }

    func popFirst() {
        self.navigationRouter.popLast(animated: false)
    }

    func pushSecond() {
        self.navigationRouter.push(.second)
    }

    func popSecond() {
        self.navigationRouter.popLast()
    }

    func popAll() {
        self.navigationRouter.popToRoot()
    }

    @MainActor
    @ViewBuilder
    func makeView(route: NavigationRoute) -> some View {
        switch route {
        case .main:
            NavigationMainView(viewmodel: NavigationMainViewModel(coordinator: self))

        case .first:
            NavigationFirstView(viewmodel: NavigationFirstViewModel(coordinator: self))

        case .second:
            NavigationSecondView(viewmodel: NavigationSecondViewModel(coordinator: self))
        }
    }
}

struct NavigationDemoView: View {
    @StateObject private var coordinator = NavigationCoordinator()

    var body: some View {
        coordinator.navigationRouter.view { route in
            coordinator.makeView(route: route)
        }
    }
}

@MainActor
protocol MainCoordinator: AnyObject {
    func pushFirst()
}

class NavigationMainViewModel: ObservableObject {
    weak var coordinator: MainCoordinator?

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
}

fileprivate struct NavigationMainView : View {
    @ObservedObject var viewmodel: NavigationMainViewModel
    var body: some View {
        VStack {
            Text("Main")
            Button("Push First") {
               viewmodel.coordinator?.pushFirst()
            }
        }
    }
}

@MainActor
protocol FirstCoordinator: AnyObject {
    func popFirst()
    func pushSecond()
}

class NavigationFirstViewModel: ObservableObject {
    weak var coordinator: FirstCoordinator?

    init(coordinator: FirstCoordinator) {
        self.coordinator = coordinator
    }

}

fileprivate struct NavigationFirstView : View {
    @ObservedObject var viewmodel: NavigationFirstViewModel
    var body: some  View {
        VStack {
            Text("View 1")
            Button("Push Second") {
                viewmodel.coordinator?.pushSecond()
            }

            Button("Pop First") {
                viewmodel.coordinator?.popFirst()
            }
        }

    }
}

@MainActor
protocol SecondCoordinator: AnyObject {
    func popSecond()
    func popAll()
}

class NavigationSecondViewModel: ObservableObject {
    weak var coordinator: SecondCoordinator?

    init(coordinator: SecondCoordinator) {
        self.coordinator = coordinator
    }

}

fileprivate struct NavigationSecondView : View {
    @ObservedObject var viewmodel: NavigationSecondViewModel
    var body: some  View {
        VStack {
            Text("View 2")
            Button("Pop Second") {
                viewmodel.coordinator?.popSecond()
            }
            Button("Pop All") {
                viewmodel.coordinator?.popAll()
            }

        }

    }
}

#Preview {
    NavigationDemoView()
}

