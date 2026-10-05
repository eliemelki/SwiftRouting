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
        ScrollView {
            VStack(spacing: 24) {
                GroupBox("Single sheet") { SheetDemoView() }
                GroupBox("Stacked sheets") { SheetsDemoView() }
                GroupBox("Navigation") { NavigationDemoView().frame(height: 300) }
                GroupBox("Tabs") { TabDemoView().frame(height: 200) }
                GroupBox("Pages") { PageDemoView().frame(height: 250) }
            }
            .padding()
        }
    }
}

#Preview { ContentView() }
