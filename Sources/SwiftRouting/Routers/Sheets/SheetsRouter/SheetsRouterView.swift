import SwiftUI

public struct SheetsRouterViewModifier<T: Route, V: View>: ViewModifier {
    @ObservedObject var router: SheetsRouter<T>
    private let makeView: @MainActor (T) -> V

    public init(router: SheetsRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public func body(content: Content) -> some View {
        content.modifier(NestedSheetRouterViewModifier(
            sheets: router.sheets + [router.placeholderSheet], makeView: makeView
        ))
    }
}

public extension View {
    func sheetsRouterView<T: Route, V: View>(_ router: SheetsRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) -> some View {
        modifier(SheetsRouterViewModifier(router: router, makeView: makeView))
    }
}

public struct SheetsRouterView<T: Route, V: View>: View {
    @ObservedObject var router: SheetsRouter<T>
    private let makeView: @MainActor (T) -> V

    public init(router: SheetsRouter<T>, @ViewBuilder makeView: @escaping @MainActor (T) -> V) {
        self.router = router
        self.makeView = makeView
    }

    public var body: some View {
        VStack {}.sheetsRouterView(router, makeView: makeView)
    }
}

// A named recursive view keeps the nested presentation type finite without AnyView.
struct NestedSheetRouterViewModifier<T: Route, V: View>: ViewModifier {
    let sheets: [SheetRouter<T>]
    let makeView: @MainActor (T) -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if let sheet = sheets.first {
            content.sheetRouterView(sheet) { route in
                NestedSheetContent(route: route, sheets: Array(sheets.dropFirst()), makeView: makeView)
            }
        } else {
            content
        }
    }
}

private struct NestedSheetContent<T: Route, V: View>: View {
    let route: T
    let sheets: [SheetRouter<T>]
    let makeView: @MainActor (T) -> V

    var body: some View {
        makeView(route).modifier(NestedSheetRouterViewModifier(sheets: sheets, makeView: makeView))
    }
}
