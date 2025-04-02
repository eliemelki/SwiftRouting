//
//  ViewFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 10/03/2025.
//

import SwiftUI

/**
  ViewFactory, as the name suggest a protocol that wraps creating views.
  Basically this will be used in Router Objects, such as Navigation and Sheets etc... to create the view.
*/
 
public protocol ViewFactory<Content> {
    associatedtype Content : View
 
    /// Called from Coordinator to create a view
    /// - return a view.
    @MainActor
    @ViewBuilder
    func createView() -> Content
}
