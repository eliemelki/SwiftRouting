//
//  SheetsRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI

public struct SheetsRouterViewModifier: ViewModifier {
    @ObservedObject var router: SheetsRouter
    
    public init(router: SheetsRouter) {
        self.router = router
    }
    
    public func body(content: Content) -> some View {
        content.buildSheetsFor(sheets: router.sheets + [router.placeholderSheet])
    }
}

extension View {
    
    public func sheetsRouterView(_ router: SheetsRouter) -> some View {
        modifier(SheetsRouterViewModifier(router: router))
    }
    
    @ViewBuilder
    func buildSheetsFor(sheets: [Sheet]) -> some View {
        if !sheets.isEmpty {
            self.modifier(sheetFor(sheets: sheets))
        } else {
            self
        }
    }
    
    func sheetFor(sheets: [Sheet]) -> some ViewModifier {
        var sheets = sheets
        let sheet = sheets.removeFirst()
        return sheet.createView { r in
            r.createView().buildSheetsFor(sheets: sheets)
        }
    }
}


public struct SheetsRouterView: View {
    @ObservedObject var router: SheetsRouter
    
    public init(router: SheetsRouter) {
        self.router = router
    }
    
    public var body: some View {
        VStack{}.buildSheetsFor(sheets: router.sheets + [router.placeholderSheet])
    }
}
