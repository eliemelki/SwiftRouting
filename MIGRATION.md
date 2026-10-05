# Migrating from SwiftRouting 1.x to 2.0.0

2.0.0 is a breaking API release. Swift 6 and iOS 16 remain the minimum requirements.
Update your package dependency to start at `2.0.0`; an existing `1.x` version range
will not select this major release automatically.

## Replace view factories with route values

Previously, destinations implemented `Routable` / `ViewFactory`, or used
`RoutableFactory` closures. Replace those objects with a route enum or struct.
`Route` requires `Hashable` and `Sendable`; it does not require `Identifiable` or
view construction. Remove erased route wrappers and `HashableByType` usage.
Keep mutable coordinators and view models out of route values.

```swift
import SwiftUI
import SwiftRouting

enum AppRoute: Route {
    case home
    case detail(Int)
}

@MainActor
@ViewBuilder
func destination(for route: AppRoute) -> some View {
    switch route {
    case .home: Text("Home")
    case .detail(let id): Text("Detail \(id)")
    }
}
```

Routers and routing calls now belong on the main actor. Mark coordinator classes
`@MainActor`. All destinations handled by one router must fit its route type.
Different destination view types are supported by `@ViewBuilder`, without `AnyView`.

## Update navigation

```swift
// Before:
// let router = NavigationRouter()
// router.setMain(homeRoutable)
// router.createView()

// After, in a main-actor coordinator:
let router = NavigationRouter<AppRoute>(root: .home)
let detail = router.push(.detail(42))
router.pop(to: detail)    // Keep this occurrence; remove entries above it.
router.pop(entry: detail) // Remove this occurrence and entries above it.
```

Build the host with `router.view { destination(for: $0) }`.

| 1.x API | 2.0.0 API |
| --- | --- |
| `NavigationRouter()` followed by `setMain(...)` | `NavigationRouter<AppRoute>(root: .home)` |
| `setMain(...)` | `setRoot(_:)` |
| `main` | `root` (required route value) |
| `paths` | `path` (array of `RouteEntry<AppRoute>`) |
| `createView()` | `view { route in ... }` |

`push` now returns `RouteEntry<T>`; callers may ignore it. `setRoot` preserves
pushed entries; call `popToRoot()` separately to clear them. `popLast` remains safe
on an empty path. Exact-entry pop requests do nothing if the entry is absent.

## Update sheets

Specify the route type and provide destination builders to each host:

```swift
@MainActor
struct SheetExample: View {
    @StateObject private var router = SheetRouter<AppRoute>()

    var body: some View {
        Button("Show details") {
            router.show(.detail(42), onDismiss: { print("Dismissed") })
        }
        .sheetRouterView(router) { route in
            destination(for: route)
        }
    }
}
```

Use `StackSheetsRouter<AppRoute>()` and `.stackSheetsRouterView(router) { ... }` for a stack.
Both routers also offer `router.view { ... }` for a standalone presenter.
Attach one host per single-sheet router: queued replacements and async dismissal
wait for the SwiftUI host's dismissal callback.

| 1.x API | 2.0.0 API |
| --- | --- |
| Single-sheet `dismissHandler:` | `onDismiss:` |
| `fullRoutable` / `partialRoutable` | `fullScreenEntry` / `partialEntry` |
| `hasSheetDisplayed()` | `isPresentingSheet` |
| `sheetType()` | `presentedSheetType` |
| `SheetsRouter` / `.sheetsRouterView(...)` | `StackSheetsRouter` / `.stackSheetsRouterView(...)` |
| Stacked `hide(routable:)` | `hide(entry:)` |
| `SheetsActions` conformance or dependency | Use the concrete typed router or your own focused protocol |

Some old state/query members were internal; the new documented queries are public.
Async single-sheet `show` returns `RouteEntry<T>`; stacked `show` and `replace`
return `RouteEntry<T>?`. Store the returned entry when you need to dismiss or
identify that exact presentation. Compare `entry.route` for destination equality;
entry identity distinguishes repeated presentations of the same route.

Synchronous sheet actions schedule a task and return immediately. Async `show`
returns after assigning the entry, before presentation animation completes.
Async `hide` waits for dismissal. Presentation bindings become nil when dismissal
begins, so state queries do not indicate animation completion.

`hideAll`, `hide(index:)`, and `hide(entry:)` on stacked sheets now dismiss the
lowest targeted sheet and its subtree in one transition. Dismissal handlers run
once per presentation, sequentially from top to bottom after that dismissal.
Update code that depended on separate dismissal animations for each sheet.
Do not await another operation on the same `SerialQueue` from inside its operation.

## Optional additions

- Use `StateRouter` to switch an app root, such as login and signed-in tabs.
  Setting the current route is a no-op; changing routes resets local destination state.
- Use `TabRouter` and `PageRouter` for typed tab/page selection.
- Apply `dynamicSheetSize()` to intrinsically sized partial-sheet content for an
  adaptive height. Avoid nested scroll views or another `presentationDetents` modifier.

These additions are optional. See the [README](README.md) for examples and the
[LB SMART demo](LBSmart/LBSmart/Bank) for coordinator ownership and session cleanup.
