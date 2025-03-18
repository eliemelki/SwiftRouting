//
//  DemoApp.swift
//  Demo
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            SingleRouterTestView()
            DefaultSheetView()
        }
    }
}

struct ExampleView: View {
    @State private var width: CGFloat = 50
    
    var body: some View {
        VStack {
            SubView()
                .frame(width: self.width, height: 120)
                .border(Color.blue, width: 2)
            
            Text("Offered Width \(Int(width))")
            Slider(value: $width, in: 0...200, step: 1)
        }
    }
}


struct SubView: View {
    var body: some View {
        GeometryReader { proxy in
            background(Color.yellow.opacity(0.7)).frame(width: proxy.size.width, height: proxy.size.height)
                
        }
    }
}


#Preview("Example") {
    ExampleView()
}
struct Y: View {
    private let viewHeight: CGFloat = 100
    @State private var position: CGFloat = 100 / 2
    @GestureState(resetTransaction: Transaction(animation: .easeOut)) private var dragHeight: CGFloat = 0

    private func clamp(_ value: CGFloat, min minValue: CGFloat, max maxValue: CGFloat) -> CGFloat {
        return min(max(value, minValue), maxValue)
    }

    var body: some View {
        GeometryReader { geometry in
            let snapTop: CGFloat = viewHeight / 2
            let snapBottom: CGFloat = geometry.size.height + geometry.safeAreaInsets.bottom + geometry.safeAreaInsets.top - (viewHeight / 2)

            ZStack {
                Rectangle()
                    .fill(Color.red)
                    .frame(height: viewHeight)
                    .position(x: geometry.size.width / 2, y: clamp(position + dragHeight, min: snapTop, max: snapBottom))
                    .gesture(
                        DragGesture()
                            .updating($dragHeight) { value, state, _ in
                                state = value.translation.height
                            }
                            .onEnded { value in
                                withAnimation(.easeOut) {
                                    position = position + value.predictedEndTranslation.height > geometry.size.height / 2 ? snapBottom : snapTop
                                }
                            }
                    )
            }
            .ignoresSafeArea()
        }
    }
}

struct D: View {
    @State private var scale = 1.0
    @State private var newScale = 1.0
    var body: some View {
        ScrollView {
            Text("Up we go")
            Text("wwer we go")
        }
        .border(.blue)
        .scaleEffect(x: 1, y: newScale)
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        
  
      
        
    }
}
#Preview("Scale") {
    D()
}


struct DescriptionView: View {
    
    var description =
"""
02.11.2021
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Illud urgueam, non intellegere eum quid sibi dicendum sit, cum dolorem summum malum esse dixerit. Omnis enim est natura diligens sui. Quamquam haec quidem praeposita recte et reiecta dicere licebit. Duo Reges: constructio interrete. Idem iste, inquam, de voluptate quid sentit? Ergo instituto veterum, quo etiam Stoici utuntur, hinc capiamus exordium. Tum ille: Tu autem cum ipse tantum librorum habeas, quos hic tandem requiris? Bona autem corporis huic sunt, quod posterius posui, similiora..
Bild © Lorem Lipsum
"""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.red
                .edgesIgnoringSafeArea(.all)
            
            Text(description)
                .foregroundColor(.white)
                .font(.headline)
                .background(
                    Rectangle()
                )
                .edgesIgnoringSafeArea(.horizontal)
            
        }
    }
}
    
#Preview {
    DescriptionView()
}

#Preview("Drag") {
    Y()
}
struct T: View {
    
    var body: some View {
       
        VStack {
            Text("Elie").padding(0)
        }
        .frame(maxWidth:.infinity)
        .background(.red)
        .border(.orange)
        
    }
}


struct X: View {
    
    @State var newWidth: CGFloat = 100
    @State var original: CGFloat = 100
    
    var body: some View {
        
        VStack {
            Slider(value: $newWidth, in: original...300, step: 1)

            VStack() {
                T().frame(height: newWidth)
                    .background(.orange)
                   .cornerRadius(20)
                  
                
            }.gesture(
                DragGesture()
                    .onChanged { value in
                        newWidth = original - value.translation.height
                       
                        // print(newWidth)
                    }
                    .onEnded { value in
                        Task { @MainActor in
                            newWidth = original
                        }
                       
                    }
            )
        }
        
    }
}

#Preview("Expand") {
    X()
}


final class CounterViewModel: ObservableObject {
    @Published var count = 0

    func incrementCounter() {
        count += 1
    }
}

struct CounterView: View {
    @StateObject var viewModel = CounterViewModel()

    var body: some View {
        VStack {
            Text("Count is: \(viewModel.count)")
            Button("Increment Counter") {
                viewModel.incrementCounter()
            }
        }
    }
}

struct RandomNumberView: View {
    @State var randomNumber = 0
    @State var viewModel: CounterViewModel = .init()

    var body: some View {
        VStack {
            Text("Random number is: \(randomNumber)")
            Button("Renew") {
                viewModel = .init()
            }
            Button("Randomize number") {
                randomNumber = (0..<1000).randomElement()!
                viewModel.incrementCounter()
            }
        }.padding(.bottom)
        
        CounterView(viewModel:viewModel)
    }
}


#Preview("StateVSObserved") {
    RandomNumberView()
}
