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
    var value = 0
    func showSheet() {
        let view = RoutableFactory { [unowned self] in
            return SR2(coordinator: self)
        }
        value += 1
        sheetRouter.show(view, sheetType: .partial, animated: value % 2 == 0) {
            print("dissmiss SR2")
        }
    }
    
    func hideSheet2() {
        value += 1
        sheetRouter.hide(animated: value % 2 == 0)
    }
    
    func replaceSheet() {
        let view = RoutableFactory { [unowned self] in
            return SR3(coordinator: self)
        }
        value += 1
        sheetRouter.show(view, sheetType: .fullScreen,animated: value % 2 == 0) {
            print("dissmiss SR3")
        }
    }
    
    func hideSHeet3() {
        value += 1
        sheetRouter.hide(animated: value % 2 == 0)
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
