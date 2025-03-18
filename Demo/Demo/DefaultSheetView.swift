//
//  DefaultSheetView.swift
//  Demo
//
//  Created by Elie Melki on 14/03/2025.
//
import SwiftUI
import SwiftRouting

class SheetObj : Identifiable {
    
}

@MainActor
class DefaultSheetViewModel : ObservableObject {
    
    @Published var isSheetVisible: SheetObj?
    @Published var isFullSheetVisible: SheetObj?
    
    let sheetRouter = SheetRouter()
    
    func showSheet() {
        self.isFullSheetVisible = SheetObj()
    }
    
    func hideSheet2() {
        self.isFullSheetVisible = nil
    }
    
    func replaceSheet() {
        self.isSheetVisible = SheetObj()
    }
    
    func hideSHeet3() {
        self.isSheetVisible = nil
    }
}

struct DefaultSheetView : View {
    @ObservedObject var viewmodel: DefaultSheetViewModel = .init()
    
    var body: some View {
        VStack {
            XSR1(coordinator: viewmodel).fullScreenCover(item: $viewmodel.isFullSheetVisible, onDismiss: {
                print("dismiss full sheet")
            }) {_ in
                XSR2(coordinator: self.viewmodel)
            }.sheet(item: $viewmodel.isSheetVisible, onDismiss: {
                print("dismiss partial sheet")
            }) {_ in
                XSR3(coordinator: self.viewmodel)
            }
        }
    }
}

struct XSR1 : View {
    let coordinator: DefaultSheetViewModel
    var body: some View {
        VStack {
            Text("SR1")
            Button("Show SR2") {
                coordinator.showSheet()
            }
        }
    }
}

struct XSR2 : View {
    let coordinator: DefaultSheetViewModel
    var body: some  View {
        VStack {
            Text("SR2")
            Button("Replace SR2 by SR3 Full") {
                coordinator.replaceSheet()
            }
            
            Button("hide SR2") {
                coordinator.hideSheet2()
            }
        }
      
    }
}

struct XSR3 : View {
    let coordinator: DefaultSheetViewModel
    var body: some  View {
        VStack {
            Text("SR3")
            Button("hide SR3") {
                coordinator.hideSHeet3()
            }
        }
      
    }
}
