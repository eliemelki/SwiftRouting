//
//  SingleRouterTestView.swift
//  Demo
//
//  Created by Elie Melki on 14/03/2025.
//
import SwiftUI
import SwiftRouting

@MainActor
class SingleRouterTestViewModel : ObservableObject {
    let sheetRouter = SheetRouter()
    
    func showSheet() {
        let view = RoutableFactory { [unowned self] in
            return SR2(coordinator: self)
        }
        Task {
            await sheetRouter.showPartial(view) {
                print("dissmiss SR2")
            }
        }
    }
    
    func hideSheet2() {
      
    }
    
    func replaceSheet() {
        let view = RoutableFactory { [unowned self] in
            return SR3(coordinator: self)
        }
        
        Task {
            await sheetRouter.showFull(view) {
                print("dissmiss SR3")
            }
        }
    }
    
    func hideSHeet3() {
        Task {
            await sheetRouter.hide()
        }
    }
}

struct SingleRouterTestView : View {
    @ObservedObject var viewmodel: SingleRouterTestViewModel = .init()
    
    var body: some View {
        VStack {
            SheetRouterView(router: viewmodel.sheetRouter)
            SR1(coordinator: viewmodel)
        }
    }
}

struct SR1 : View {
    let coordinator: SingleRouterTestViewModel
    var body: some View {
        VStack {
            Text("SR1")
            Button("Show SR2") {
                coordinator.showSheet()
            }
        }
    }
}

struct SR2 : View {
    let coordinator: SingleRouterTestViewModel
    var body: some  View {
        VStack {
            Text("SR2")
            Button("Replace SR2 by SR3 Full") {
                coordinator.replaceSheet()
            }
            
            Button("hide SR2") {
                coordinator.hideSheet2()
            }
        }
      
    }
}

struct SR3 : View {
    let coordinator: SingleRouterTestViewModel
    var body: some  View {
        VStack {
            Text("SR3")
            Button("hide SR3") {
                coordinator.hideSHeet3()
            }
        }
      
    }
}
