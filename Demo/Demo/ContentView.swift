//
//  ContentView.swift
//  Demo
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI
import SwiftRouting



@MainActor
 class AppCordinator: ObservableObject  {
    let sheetsRouter = SheetsRouter()
    weak var secondSheet: AnyRoutable?
    
    func showFirstSheet() {
        let view = RoutableFactory { [unowned self] in
            return TestView1(coordinator: self)
        }
        sheetsRouter.show(view) {
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
        sheetsRouter.hideAll(animated: true)
    }
}

 struct ContentView: View {
    @StateObject var appCordinator = AppCordinator()
    
    var body: some View {
        VStack {
            TestView(coordinator: appCordinator)
        }.sheetsRouterView(appCordinator.sheetsRouter)
    }
}

 struct TestView : View {
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

 struct TestView1 : View {
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

 struct TestView2 : View {
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

 struct TestView2Replaced : View {
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

 struct TestView3 : View {
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


 struct TX : View {
    var value: CustomWrapper
    
    init(value: CustomWrapper) {
        self.value = value
        print("here")
    }
    
    var body: some  View {
        VStack {
            let _ = print("redraw")
            Text("\(value.wrappedValue)")
            Button("Increment value") {
                value.wrappedValue += 1
            }
        }
    }

}
#Preview {
    let _ = UserDefaults.standard.removeObject(forKey: "v")
    TX(value: CustomWrapper.init(wrappedValue: 1))
}

class Obs<Value>: ObservableObject {
    
    var v: Value?  {  get {
        let v = UserDefaults.standard.value(forKey: "v") as? Value
        return v
    }
        
        set {
            objectWillChange.send()
            
            UserDefaults.standard.set(newValue, forKey: "v")
        }
    }
}



struct CustomWrapper: DynamicProperty {
    @StateObject var obs: Obs<Int> = .init()
    var initialValue: Int
    
    public init(wrappedValue value: Int) {
        self.initialValue = value
    

    }

     var wrappedValue: Int {
         get {
             return Int.random(in: 0...10000)
         }

         nonmutating set {
             print("BeforeChange")
             obs.objectWillChange.send()
             print("After Change")
         }
     }
    
    var projectedValue: Binding<Int> {
            .init(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            )
        }
    
    mutating func update() {
        print("update")
        //dump(self)
    }
}

import Combine
public protocol XObservableObject : AnyObject {

 
    associatedtype ObjectWillChangePublisher : Publisher = XObservableObjectPublisher where Self.ObjectWillChangePublisher.Failure == Never

    /// A publisher that emits before the object has changed.
    var objectWillChange: Self.ObjectWillChangePublisher { get }
}


extension XObservableObject{

    /// A publisher that emits before the object has changed.
    public var objectWillChange: XObservableObjectPublisher {
        fatalError()
    }
}


final public class XObservableObjectPublisher : Publisher {
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
        
    }
    
    /// The kind of values published by this publisher.
    public typealias Output = Void

    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    public typealias Failure = Never

    /// Creates an observable object publisher instance.
    public init() {
        
    }
    
}
