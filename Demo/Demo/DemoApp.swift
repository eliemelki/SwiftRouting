//
//  DemoApp.swift
//  Demo
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI

struct Myclass {
    var x = 1
}


struct SomeData {
    var x: Int
}


struct ChildViewV: View {
    
    var body: some View {
        VStack {
        }
    }
}

struct ChildViewX: View {
  
    @State var data: SomeData = SomeData(x: 1)
    var body: some View {
       // let _ = dump(self)
        VStack {
           
            let _ = print("redraw")
            ChildViewV()
            Text("\(data.x)")
            Button("dum") {
                //let _ = dump(body)
                data.x += 1
            }
            let _ = Self._printChanges()
        }
    }
    
//    nonisolated public static func _makeView(view: _GraphValue<Self>, inputs: _ViewInputs) -> _ViewOutputs {
//        fatalError()
//    }
//    
//    nonisolated static func _makeViewList(view: _GraphValue<Self>, inputs: _ViewListInputs) -> _ViewListOutputs {
//        fatalError()
//    }
}


@main

struct DemoApp: App {
    //@State var store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// OuterViewModel
class OuterViewModel: ObservableObject {
    @Published var innerViewModel: InnerViewModel = InnerViewModel()
    
    
}

// InnerViewModel
class InnerViewModel: ObservableObject {
    @Published var color: Color = .red
}

// ContentView
struct XX: View {
    @StateObject private var outerViewModel = OuterViewModel()

    var body: some View {
        VStack {
            Text("Color: \(outerViewModel.innerViewModel.color.description)")
                .padding()

            Button("Change Color") {
                outerViewModel.innerViewModel.color = .blue
            }
        }
    }
}

//struct SubView: View {
//    @MyWrapper var store: AppStore
//    
//    var body: some View {
//        let _ = print("SubView")
//        Text("\(store.date)")
//        Button("Child Modify Date") {
//            self.store.date += 1
//        }
//    }
//}

struct AppStore  {
     var date: Int = 1
}


@propertyWrapper
struct MyState<Value>: DynamicProperty {
    private var _value: Value
    private var _location: AnyLocation<Value>?
    
    init(wrappedValue: Value) {
        self._value = wrappedValue
        self._location = AnyLocation(value: wrappedValue)
    }
    
    var wrappedValue: Value {
        get { _location?._value.pointee ?? _value }
        nonmutating set { _location?._value.pointee = newValue }
    }
    
    var projectedValue: Binding<Value> {
        Binding<Value>(
            get: { self.wrappedValue },
            set: { self._location?._value.pointee = $0 }
        )
    }
    
    func update() {
        print("Redraw view")
    }
}

class AnyLocation<Value> {
    let _value = UnsafeMutablePointer<Value>.allocate(capacity: 1)
    init(value: Value) {
        self._value.pointee = value
    }
}

import Combine
/// Parent's State
@propertyWrapper
class BindingWrapper<Value> {
    private var _value: Value
    private let _publisher: CurrentValueSubject<Value, Never>

    init(wrappedValue: Value) {
        _value = wrappedValue
        _publisher = CurrentValueSubject(wrappedValue)
    }

    var wrappedValue: Value {
        get { _value }
        set {
            _value = newValue
            _publisher.send(newValue)
        }
    }

    var projectedValue: CurrentValueSubject<Value, Never> {
        _publisher
    }
}
//
// Usage in Parent
struct ParentView: View {
    @State private var myState = "Initial Value"
    @BindingWrapper var myBoundState: Int

    var body: some View {
        Text("\(myBoundState)")
        ChildView(myBoundState: myBoundState)
        Button("Update State") {
            myBoundState += 1
        }
    }
}

// Usage in Child
struct ChildView: View {
    @State private var myState = "Initial Value"
    @BindingWrapper var myBoundState: Int

    var body: some View {
        Text("Child \(myBoundState)")
        Button("Child  Update State") {
            myBoundState += 1
        }
    }
}

//
//struct ExampleView: View {
//    @State private var width: CGFloat = 50
//    
//    var body: some View {
//        VStack {
//            SubView()
//                .frame(width: self.width, height: 120)
//                .border(Color.blue, width: 2)
//            
//            Text("Offered Width \(Int(width))")
//            Slider(value: $width, in: 0...200, step: 1)
//        }
//    }
//}
//
//
//struct SubView: View {
//    var body: some View {
//        GeometryReader { proxy in
//            background(Color.yellow.opacity(0.7)).frame(width: proxy.size.width, height: proxy.size.height)
//                
//        }
//    }
//}
//
//
//#Preview("Example") {
//    ExampleView()
//}
//struct Y: View {
//    private let viewHeight: CGFloat = 100
//    @State private var position: CGFloat = 100 / 2
//    @GestureState(resetTransaction: Transaction(animation: .easeOut)) private var dragHeight: CGFloat = 0
//
//    private func clamp(_ value: CGFloat, min minValue: CGFloat, max maxValue: CGFloat) -> CGFloat {
//        return min(max(value, minValue), maxValue)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            let snapTop: CGFloat = viewHeight / 2
//            let snapBottom: CGFloat = geometry.size.height + geometry.safeAreaInsets.bottom + geometry.safeAreaInsets.top - (viewHeight / 2)
//
//            ZStack {
//                Rectangle()
//                    .fill(Color.red)
//                    .frame(height: viewHeight)
//                    .position(x: geometry.size.width / 2, y: clamp(position + dragHeight, min: snapTop, max: snapBottom))
//                    .gesture(
//                        DragGesture()
//                            .updating($dragHeight) { value, state, _ in
//                                state = value.translation.height
//                            }
//                            .onEnded { value in
//                                withAnimation(.easeOut) {
//                                    position = position + value.predictedEndTranslation.height > geometry.size.height / 2 ? snapBottom : snapTop
//                                }
//                            }
//                    )
//            }
//            .ignoresSafeArea()
//        }
//    }
//}
//
//struct D: View {
//    @State private var scale = 1.0
//    @State private var newScale = 1.0
//    var body: some View {
//        ScrollView {
//            Text("Up we go")
//            Text("wwer we go")
//        }
//        .border(.blue)
//        .scaleEffect(x: 1, y: newScale)
//        .frame(height: 300)
//        .frame(maxWidth: .infinity)
//        
//  
//      
//        
//    }
//}
//#Preview("Scale") {
//    D()
//}
//
//
//struct DescriptionView: View {
//    
//    var description =
//"""
//02.11.2021
//Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illud urgueam, non intellegere eum quid sibi dicendum sit, cum dolorem summum malum esse dixerit. Omnis enim est natura diligens sui. Quamquam haec quidem praeposita recte et reiecta dicere licebit. Duo Reges: constructio interrete. Idem iste, inquam, de voluptate quid sentit? Ergo instituto veterum, quo etiam Stoici utuntur, hinc capiamus exordium. Tum ille: Tu autem cum ipse tantum librorum habeas, quos hic tandem requiris? Bona autem corporis huic sunt, quod posterius posui, similiora..
//Bild © Lorem Lipsum
//"""
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Color.red
//                .edgesIgnoringSafeArea(.all)
//            
//            Text(description)
//                .foregroundColor(.white)
//                .font(.headline)
//                .background(
//                    Rectangle()
//                )
//                .edgesIgnoringSafeArea(.horizontal)
//            
//        }
//    }
//}
//    
//#Preview {
//    DescriptionView()
//}
//
//#Preview("Drag") {
//    Y()
//}
//struct T: View {
//    
//    var body: some View {
//       
//        VStack {
//            Text("Elie").padding(0)
//        }
//        .frame(maxWidth:.infinity)
//        .background(.red)
//        .border(.orange)
//        
//    }
//}
//
//
//struct X: View {
//    
//    @State var newWidth: CGFloat = 100
//    @State var original: CGFloat = 100
//    
//    var body: some View {
//        
//        VStack {
//            Slider(value: $newWidth, in: original...300, step: 1)
//
//            VStack() {
//                T().frame(height: newWidth)
//                    .background(.orange)
//                   .cornerRadius(20)
//                  
//                
//            }.gesture(
//                DragGesture()
//                    .onChanged { value in
//                        newWidth = original - value.translation.height
//                       
//                        // print(newWidth)
//                    }
//                    .onEnded { value in
//                        Task { @MainActor in
//                            newWidth = original
//                        }
//                       
//                    }
//            )
//        }
//        
//    }
//}
//
//#Preview("Expand") {
//    X()
//}
//
//
//final class CounterViewModel: ObservableObject {
//    @Published var count = 0
//
//    func incrementCounter() {
//        count += 1
//    }
//}
//
//struct CounterView: View {
//    @StateObject var viewModel = CounterViewModel()
//
//    var body: some View {
//        VStack {
//            Text("Count is: \(viewModel.count)")
//            Button("Increment Counter") {
//                viewModel.incrementCounter()
//            }
//        }
//    }
//}
//
//struct RandomNumberView: View {
//    @State var randomNumber = 0
//    @State var viewModel: CounterViewModel = .init()
//
//    var body: some View {
//        VStack {
//            Text("Random number is: \(randomNumber)")
//            Button("Renew") {
//                viewModel = .init()
//            }
//            Button("Randomize number") {
//                randomNumber = (0..<1000).randomElement()!
//                viewModel.incrementCounter()
//            }
//        }.padding(.bottom)
//        
//        CounterView(viewModel:viewModel)
//    }
//}
//
//
//#Preview("StateVSObserved") {
//    RandomNumberView()
//}
