//
//  Test.swift
//  SwiftRouting
//
//  Created by Elie Melki on 16/04/2025.
//

import Foundation


class Test {
    static func isRunningTests() -> Bool {
        return NSClassFromString("SwiftRoutingTests.MockSheetRouter") != nil
    }
}
