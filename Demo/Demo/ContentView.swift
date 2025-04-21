//
//  ContentView.swift
//  Demo
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI
@testable import SwiftRouting


 struct ContentView: View {
    
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
