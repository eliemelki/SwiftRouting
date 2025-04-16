//
//  SheetRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI

@MainActor
fileprivate class Coordinator : ObservableObject {
    let sheetRouter = SheetRouter()
    
    var value = 0
    
    func showSheet1() {
        let routable = RoutableFactory { [unowned self] in
            return SheetView1(coordinator: self)
        }
        sheetRouter.show(routable, sheetType: .partial) {
            print("dismissed SheetView1")
        }
    }
    
    func hideSheet1() {
        value += 1
        //sheetRouter.hide(animated: value % 2 == 0)
        sheetRouter.hide()
    }
    
    func replaceSheet1BySheet2() {
        let routable = RoutableFactory { [unowned self] in
            return SheetView2(coordinator: self)
        }
        value += 1
//        sheetRouter.show(routable, sheetType: .fullScreen,animated: value % 2 == 0) {
//            print("dismiss SheetView2")
//        }
        sheetRouter.show(routable, sheetType: .fullScreen) {
            print("dismiss SheetView2")
        }
    }
    
    func hideSheet2() {
        value += 1
        //sheetRouter.hide(animated: value % 2 == 0)
        sheetRouter.hide()
    }
}

fileprivate struct SheetRouterDemo : View {
    @ObservedObject var coordinator: Coordinator = .init()
    
    var body: some View {
        VStack {
            SheetBase(coordinator: coordinator)
        }.sheetRouterView(coordinator.sheetRouter)
    }
}

fileprivate struct SheetBase : View {
    let coordinator: Coordinator
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
    let coordinator: Coordinator
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
    let coordinator: Coordinator
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
    SheetRouterDemo()
}

