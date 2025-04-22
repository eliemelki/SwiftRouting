//
//  SheetsRouterDemo.swift
//  SwiftRouting
//
//  Created by Elie Melki on 03/04/2025.
//

import SwiftUI


@MainActor
class SheersCordinator: ObservableObject  {
    let sheetsRouter = SheetsRouter()
    weak var secondSheet: AnyRoutable?
    
    func showFirstSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView1(coordinator: self)
        }
        sheetsRouter.show(view, animated: false) {
            print("dimiss First")
        }
    }
    
    func showSecondSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView2(coordinator: self)
        }
        
        Task {
            secondSheet = await sheetsRouter.show(view) {
                print("dimiss Second")
                
            }
        }
    }
    
    func replaceSecondSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView2Replaced(coordinator: self)
        }
        Task {
            secondSheet = await sheetsRouter.replace(view) {
                print("dimiss second Replaced")
            }
        }
    }
    
    func showThirdSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView3(coordinator: self)
        }
        sheetsRouter.show(view) {
            print("dimiss Third")
        }
    }
    
    func hideLast() {
        sheetsRouter.hide()
    }
    
    func backToFirst() {
        
        guard let secondSheet else { return }
        sheetsRouter.hide(routable: secondSheet)
    }
    
    func hide() {
        sheetsRouter.hideAll(animated: false)
    }
}

struct SheetsDemoView: View {
    @StateObject var appCordinator = SheersCordinator()
    
    var body: some View {
        VStack {
            TestView(coordinator: appCordinator)
        }
        .sheetsRouterView(appCordinator.sheetsRouter)
    }
}

fileprivate struct TestView : View {
    let coordinator: SheersCordinator
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
    let coordinator: SheersCordinator
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
    let coordinator: SheersCordinator
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
    let coordinator: SheersCordinator
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
    let coordinator: SheersCordinator
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
