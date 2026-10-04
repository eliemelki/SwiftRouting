
import SwiftUI

enum NavigationRoute: Route {
    case main
    case first
    case second
}

@MainActor
class NavigationCoordinator: MainCoordinator,
                             FirstCoordinator,
                             SecondCoordinator {
    
    let navigationRouter : NavigationRouter<NavigationRoute>
    
    init() {
        navigationRouter = NavigationRouter<NavigationRoute>(main: .main)
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
    
    
    private var mainViewModel: NavigationMainViewModel?
    private var firstViewModel: NavigationFirstViewModel?
    private var secondViewModel: NavigationSecondViewModel?
    
 
    @MainActor
    @ViewBuilder
    func showNavigationView(route: NavigationRoute) -> some View {
        switch route {
        case .main:
            let viewModel = {
                let model = NavigationMainViewModel(coordinator: self)
                mainViewModel = model
                return model
            }()
            NavigationMainView(viewmodel: viewModel)

        case .first:
            let viewModel = {
                let model = NavigationFirstViewModel(coordinator: self)
                firstViewModel = model
                return model
            }()
            NavigationFirstView(viewmodel: viewModel)

        case .second:
            let viewModel = {
                let model = NavigationSecondViewModel(coordinator: self)
                secondViewModel = model
                return model
            }()
            NavigationSecondView(viewmodel: viewModel)
        }
    }
}




@MainActor
class NavigationDemoViewModel : ObservableObject {
    
    let coordinator: NavigationCoordinator = .init()
    
    init() {
        
    }
}

struct NavigationDemoView : View {
    @ObservedObject var viewModel: NavigationDemoViewModel = .init()
    
    var body: some View {
        viewModel.coordinator.navigationRouter.view { route in
            viewModel.coordinator.showNavigationView(route: route)
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
   // func showSheet()
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
            Button("Show Sheet") {
               // model.coordinator.showSheet()
            }
            Button("Pop Second") {
                viewmodel.coordinator?.popSecond()
            }
            Button("Pop All") {
                viewmodel.coordinator?.popAll()
            }
            
        }
        
    }
}

@MainActor
protocol NavigationSheetCoordinator {
    func pop()
    func hideSheet()
}

fileprivate struct SheetView : View {
    let coordinator: NavigationSheetCoordinator
    var body: some  View {
        VStack {
            Text("Sheet")
            Button("hide Sheet") {
                coordinator.hideSheet()
            }
            Button("Pop") {
                coordinator.pop()
            }
        }
        
    }
}

#Preview {
    NavigationDemoView()
}

