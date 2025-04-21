
import SwiftUI

@MainActor
class NavigationCoordinator :
    ObservableObject,
    MainCoordinator,
    FirstCoordinator,
    SecondCoordinator,
    NavigationSheetCoordinator
{
    
    let router = NavigationRouter()
    let sheetsRouter = SheetsRouter()
    
    init() {
        setupMain()
        
    }
    func setupMain() {
        let routable = RoutableFactory { [unowned self] in
            return NavigationMain(coordinator: self)
        }
        router.setMain(routable)
        
    }
    
    func dimissFirst() {
        self.router.popLast()
    }
    
    func pushFirst() {
        let routable = RoutableFactory { [unowned self] in
            return NavigationFirstView(coordinator: self)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            self.dimissFirst()
                        }) {
                            Label("Back", systemImage: "arrow.left.circle")
                        }
                    }
                }
        }
        router.push(routable)
    }
    
    func popFirst() {
        router.popLast()
    }
    
    func pushSecond() {
        let routable = RoutableFactory { [unowned self] in
            return NavigationSecondView(coordinator: self)
        }
        
        router.push(routable)
    }
    
    func popSecond() {
        router.popLast()
    }
    
    func popAll() {
        router.popToRoot()
    }
    
    func showSheet() {
        let routable = RoutableFactory { [unowned self] in
            return SheetView(coordinator: self)
        }
        sheetsRouter.show(routable)
    }
    
    func pop() {
        router.popLast()
    }
    
    func hideSheet() {
        sheetsRouter.hide()
    }
}

struct NavigationDemoView : View {
    @ObservedObject var coordinator: NavigationCoordinator = .init()
    
    var body: some View {
        NavigationRouterView(router: coordinator.router)
            .sheetsRouterView(coordinator.sheetsRouter)
    }
}

@MainActor
protocol MainCoordinator {
    func pushFirst()
}

fileprivate struct NavigationMain : View {
    let coordinator: MainCoordinator
    var body: some View {
        VStack {
            Text("Main")
            Button("Push First") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    coordinator.pushFirst()
                }
            }
        }
    }
}

@MainActor
protocol FirstCoordinator {
    func popFirst()
    func pushSecond()
}

fileprivate struct NavigationFirstView : View {
    let coordinator: FirstCoordinator
    var body: some  View {
        VStack {
            Text("View 1")
            Button("Push Second") {
                coordinator.pushSecond()
            }
            
            Button("Pop First") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    coordinator.popFirst()
                }
            }
        }
        
    }
}

@MainActor
protocol SecondCoordinator {
    func popSecond()
    func popAll()
    func showSheet()
}

fileprivate struct NavigationSecondView : View {
    let coordinator: SecondCoordinator
    var body: some  View {
        VStack {
            Text("View 2")
            Button("Show Sheet") {
                coordinator.showSheet()
            }
            Button("Pop Second") {
                coordinator.popSecond()
            }
            Button("Pop All") {
                coordinator.popAll()
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

