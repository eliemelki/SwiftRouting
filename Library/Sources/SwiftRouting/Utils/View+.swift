//
//  View+.swift
//  SwiftRouting
//
//  Created by Elie Melki on 12/03/2025.
//
import SwiftUI

public extension View {
    @ViewBuilder
    func apply<Content: View>(_ shouldApply: Bool, content: (Self) -> Content) -> some View {
        if (shouldApply) {
            content(self)
        }else {
            self
        }
        
    }
}
