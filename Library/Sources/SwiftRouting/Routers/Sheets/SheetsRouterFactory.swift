//
//  SheetsFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 24/03/2025.
//

import Combine
import SwiftUI

@MainActor
protocol SheetsRouterFactory {
    func instanceOfSheet() -> Sheet
}

struct DefaultSheetsRouterFactory: SheetsRouterFactory {
    func instanceOfSheet() -> Sheet {
        return SheetRouter()
    }
}

