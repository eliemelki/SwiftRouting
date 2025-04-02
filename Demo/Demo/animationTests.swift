//
//  animationTests.swift
//  Demo
//
//  Created by Elie Melki on 26/03/2025.
//
import SwiftUI

extension View {
    @ViewBuilder
    func transactionMonitor(_ title: String, _ showAnimation: Bool = true) -> some View {
        transaction {
            print(title, terminator: showAnimation ? ": " : "\n")
            if showAnimation {
                print($0.animation ?? "nil")
            }
        }
    }
}

struct ImplicitAnimationDemo: View {
    @State private var isActive = false
    var body: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .offset(x: isActive ? 200 : 0)
                .transactionMonitor("inner")
                .animation(.smooth, value: isActive)
                .transactionMonitor("outer")

            Text("World")
                .transactionMonitor("world")

            Toggle("Active", isOn: $isActive)
                .padding()
        }
        .transactionMonitor("VStack")
        .animation(.easeIn(duration: 2), value: isActive)
    }
}

#Preview {
    ImplicitAnimationDemo()
}

struct AnimationDataMonitorView: View, Animatable {
    static var timestamp = Date()
    var number: Double
    var animatableData: Double { // When rendering, SwiftUI detects that this view is Animatable and continues to call animableData based on the values provided by the timing curve function after the state has changed.
        get { number }
        set { number = newValue }
    }

    var body: some View {
        let duration = Date().timeIntervalSince(Self.timestamp).formatted(.number.precision(.fractionLength(2)))
        let currentNumber = number.formatted(.number.precision(.fractionLength(2)))
        let _ = print(duration, currentNumber, separator: ",")

        Text(number, format: .number.precision(.fractionLength(3)))
    }
}

struct Demo: View {
    @State var startAnimation = false
    var body: some View {
        VStack {
            AnimationDataMonitorView(number: startAnimation ? 1 : 0) // Declare the two states
                .animation(.linear(duration: 0.3), value: startAnimation) // Associate dependencies and timing curve functions
            Button("Show Data") {
                AnimationDataMonitorView.timestamp = Date()
                startAnimation.toggle() // Change dependencies
            }
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    Demo()
}
