//
//  ContentView.swift
//  Demo
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI
@testable import SwiftRouting


 struct ContentView: View {
    
    let sheetsRouter = SheetsRouter()
    @State var showSheet = false
    var body: some View {
        VStack {
            VStack {
                Text("Sheet Demo")
                SheetDemoView()
            }
            .frame(maxWidth: .infinity)
            .border(Color.black)
            
            VStack {
                Text("Sheets Demo")
                SheetsDemoView()
            }
            .frame(maxWidth: .infinity)
            .border(Color.black)
            VStack {
                Text("Navigation Demo")
                NavigationDemoView()
            }
            .border(Color.black)
        }
    }
}

#Preview {
    ContentView()
}

struct NavigationStackDemo: View {
    @ObservedObject var pathStore = PathStore()
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            AnyView(List {
                Button("Go Link without Animation") {
                    
                        pathStore.add()
                }
                Button("Go Link with Animation") {
                    pathStore.add()
                }
            })
            .navigationDestination(for: Int.self) {
                AnyView(ChildView(store: pathStore, n: $0))
            }
        }
    }
}

class PathStore : ObservableObject {
    @Published var path: [Int] = []
    
    func remove() {
       
            path = []
        
    }
    func add() {
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path.append(path.count)
        }
    }
}
struct ChildView: View {
    @ObservedObject var store: PathStore
    let n: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            Text("\(n)")
            Button("Go Link  Animation") {
     
                    store.add()
            }
            Button("Dismiss without Animation") {

                store.remove()
                
            }
            Button("Dismiss with Animation") {
                dismiss()
            }
        }
    }
}

struct SheetDemo: View {
    @State private var isActive = false
    var body: some View {
        List {
            Button("Pop Sheet without Animation") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isActive.toggle()
                }
            }
            Button("Pop Sheet with Animation") {
                isActive.toggle()
            }
        }
        .sheet(isPresented: $isActive) {
            VStack {
                Button("Dismiss without Animation") {
                    var transaction = Transaction(animation: .none)
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isActive.toggle()
                    }
                }
                Button("Dismiss with Animation") {
                    
                    isActive.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
