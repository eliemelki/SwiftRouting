//
//  DynamicSheetLayoutTests.swift
//  LBSmartTests
//
//  Created by Elie Melki on 05/10/2026.
//

import SwiftUI
import SwiftRouting
import Testing
import UIKit

@MainActor
private final class SheetLayoutModel: ObservableObject {
    @Published var isPresented = false
    @Published var isExpanded = false
}

private struct SheetLayoutHost: View {
    @ObservedObject var model: SheetLayoutModel

    var body: some View {
        Color.clear.sheet(isPresented: $model.isPresented) {
            VStack(spacing: 0) {
                Text("Content-sized sheet").frame(height: 120)
                if model.isExpanded {
                    Text("Additional content").frame(height: 180)
                }
            }
            .padding(20)
            .dynamicSheetSize()
        }
    }
}

@MainActor
@Test func testDynamicSheetTracksActualRenderedContentHeight() async throws {
    let model = SheetLayoutModel()
    let host = UIHostingController(rootView: SheetLayoutHost(model: model))
    let scene = try #require(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first)
    let previousWindow = scene.windows.first { $0.isKeyWindow }
    let window = UIWindow(windowScene: scene)
    window.rootViewController = host
    window.makeKeyAndVisible()
    defer {
        host.dismiss(animated: false)
        window.isHidden = true
        previousWindow?.makeKeyAndVisible()
    }
    host.loadViewIfNeeded()
    model.isPresented = true
    let fitted = await waitForLayout {
        guard let sheet = host.presentedViewController else { return false }
        return sheet.view.bounds.height > 120 && sheet.view.bounds.height < 250
    }
    #expect(fitted)
    let sheet = try #require(host.presentedViewController)
    let initialHeight = sheet.view.bounds.height
    model.isExpanded = true
    let expanded = await waitForLayout { sheet.view.bounds.height > initialHeight + 100 }
    #expect(expanded)
    model.isExpanded = false
    let collapsed = await waitForLayout { abs(sheet.view.bounds.height - initialHeight) < 5 }
    #expect(collapsed)
}

@MainActor
private func waitForLayout(_ condition: () -> Bool) async -> Bool {
    for _ in 0..<40 {
        if condition() { return true }
        try? await Task.sleep(nanoseconds: 100_000_000)
    }
    return condition()
}
