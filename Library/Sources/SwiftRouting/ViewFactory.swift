//
//  ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 10/03/2025.
//


import SwiftUI


public protocol ViewFactory<Content>: AnyObject {
    associatedtype Content : View
 
    @MainActor
    @ViewBuilder
    func createView() -> Content
}
