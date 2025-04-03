//
//  SheetsRouterView.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//
import SwiftUI

public struct SheetsRouterView: View {
    @ObservedObject var router: SheetsRouter
    
    public init(router: SheetsRouter) {
        self.router = router
    }
    
    public var body: some View {
        VStack{}.buildSheetsFor(sheets: router.sheets + [router.placeholderSheet])
    }
}

extension View {
    @ViewBuilder
    func buildSheetsFor(sheets: [Sheet]) -> some View {
        if !sheets.isEmpty {
            self.sheetFor(sheets: sheets)
        } else {
            self
        }
    }
    
    func sheetFor(sheets: [Sheet]) -> some View {
        var sheets = sheets
        let sheet = sheets.removeFirst()
        return sheet.createView {
            buildSheetsFor(sheets: sheets)
        }
    }
}
