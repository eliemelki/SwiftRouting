//
//  DynamicSheetSize.swift
//  SwiftRouting
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI

public extension View {
    /// Fits a partial sheet to this content's measured height, updating as it changes.
    ///
    /// Apply to the destination inside a sheet, including its desired padding.
    /// The content is placed in a vertical scroll view so it remains reachable when
    /// its ideal height exceeds the system's maximum sheet height. Use intrinsically
    /// sized content, such as a VStack; avoid a List, nested ScrollView, or expanding Spacer.
    /// Do not combine this modifier with another `presentationDetents` modifier.
    /// The initial layout uses a large detent until a valid measurement is available.
    func dynamicSheetSize() -> some View {
        modifier(DynamicSheetSizeModifier())
    }
}

private struct DynamicSheetSizeModifier: ViewModifier {
    @State private var contentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .background {
                    GeometryReader { geometry in
                        Color.clear.preference(key: SheetContentHeightKey.self, value: geometry.size.height)
                    }
                }
        }
        .presentationDetents([contentHeight > 0 ? .height(contentHeight) : .large])
        .onPreferenceChange(SheetContentHeightKey.self) { height in
            guard height.isFinite, height > 0 else { return }
            let roundedHeight = ceil(height)
            guard roundedHeight != contentHeight else { return }
            contentHeight = roundedHeight
        }
    }
}

private struct SheetContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
