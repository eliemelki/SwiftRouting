//
//  SheetsRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI
import SwiftRouting


@MainActor
fileprivate class AppCordinator: ObservableObject  {
    let sheetRouter = SheetsRouter()
    weak var secondSheet: AnyRoutable?
    
    func showFirstSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView1(coordinator: self)
        }
        sheetRouter.show(view) {
            print("dimiss First")
        }
    }
    
    func showSecondSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView2(coordinator: self)
        }
        
        Task {
            secondSheet = await sheetRouter.show(view) {
                print("dimiss Second")
                
            }
        }
    }
    
    func replaceSecondSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView2Replaced(coordinator: self)
        }
        Task {
            secondSheet = await sheetRouter.replace(view) {
                print("dimiss second Replaced")
            }
        }
    }
    
    func showThirdSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView3(coordinator: self)
        }
        sheetRouter.show(view) {
            print("dimiss Third")
        }
    }
    
    func hideLast() {
        
        sheetRouter.hide()
        //self.showSecondSheet()
        
    }
    
    func backToFirst() {
        
        guard let secondSheet else { return }
        sheetRouter.hide(routable: secondSheet)
    }
    
    func hide() {
        sheetRouter.hideAll(animated: false)
    }
}

fileprivate struct ContentView: View {
    @StateObject var appCordinator = AppCordinator()
    
    var body: some View {
        VStack {
            appCordinator.sheetRouter.createView()
            TestView(coordinator: appCordinator)
        }
    }
}

fileprivate struct TestView : View {
    let coordinator: AppCordinator
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
    let coordinator: AppCordinator
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
    let coordinator: AppCordinator
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
    let coordinator: AppCordinator
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
    let coordinator: AppCordinator
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
    ContentView()
}
