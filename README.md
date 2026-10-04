# SwiftRouting

SwiftRouting separates SwiftUI destination views from the code that decides when
to navigate, present a sheet, switch tabs, or change pages. It supports iOS 16 and
later and uses Swift 6.

## Routes and entries

A `Route` is a `Hashable & Sendable` destination value. Use an enum or struct and
build its view in a separate `@ViewBuilder` closure. Keep route values stable;
changing a reference type's hash while it is stored can break selection or navigation.

```swift
import SwiftUI
import SwiftRouting

enum AppRoute: Route {
    case home
    case settings
    case detail(Int)
}

@MainActor
@ViewBuilder
func destination(for route: AppRoute) -> some View {
    switch route {
    case .home: Text("Home")
    case .settings: Text("Settings")
    case .detail(let id): Text("Detail \(id)")
    }
}
```

`RouteEntry<T>` represents one occurrence of a route. Each new entry receives a
fresh UUID. Compare `entry.route` for destination equality and `entry.id` for
occurrence identity. Entry equality and hashing include both fields. Repeated
routes can therefore appear independently in navigation paths, sheets, tabs, and pages.

Routers are main-actor observable objects. Own them in a coordinator or with
`@StateObject`; the router views observe an existing instance. Typed view builders
support different destination view types without view erasure. Routers store route
values; the host view supplies their destination views.

## Routers

| Router | Behavior |
| --- | --- |
| `NavigationRouter<T>` | A root destination with a stack of pushed entries. |
| `SheetRouter<T>` | One partial sheet or full-screen cover; showing another replaces it. |
| `SheetsRouter<T>` | A stack of partial sheets and full-screen covers. |
| `TabRouter<T>` | A fixed collection of tabs with a selected entry. |
| `PageRouter<T>` | A fixed collection of swipeable pages with a selected entry. |

All five routers expose `view(...)` to build a host view. Sheet routers also have
view modifiers for attaching their presenters to existing content.

### Navigation

```swift
@MainActor
struct NavigationExample: View {
    @StateObject private var router = NavigationRouter<AppRoute>(root: .home)

    var body: some View {
        router.view { route in
            destination(for: route)
        }
    }
}
```

- `root` is the destination below the pushed stack.
- `path` contains pushed `RouteEntry` values. SwiftUI updates it when the user goes back.
- `push(_:animated:)` appends a new occurrence, even when the route repeats.
- `popLast(animated:)` removes the last entry; an empty path is unchanged.
- `popToRoot(animated:)` removes every pushed entry.
- `setRoot(_:)` replaces the root while preserving the path. Call `popToRoot()`
  separately when you also want to clear the stack.

See [NavigationRouterDemo](Sources/SwiftRouting/Routers/Navigation/NavigationRouterDemo.swift).

### Single sheet

```swift
@MainActor
struct SheetExample: View {
    @StateObject private var router = SheetRouter<AppRoute>()

    var body: some View {
        Button("Show settings") {
            router.show(.settings, onDismiss: { print("Settings dismissed") })
        }
        .sheetRouterView(router) { route in
            destination(for: route)
        }
    }
}
```

`show(_:sheetType:animated:onDismiss:)` presents a route as `.partial` by default,
or as `.fullScreen`. If a presentation already exists, the router waits for its
dismissal callback before assigning a new entry. `onDismiss` runs once for each
presentation, including when it is replaced.

The async overload returns the new entry after assigning the presentation binding;
it does not wait for the new presentation animation to finish. Async
`hide(animated:)` waits for the dismissal callback. Overloads without `await`
schedule the same actions in tasks and return immediately.

```swift
// Inside a main-actor async function:
let entry = await router.show(.detail(42), sheetType: .fullScreen)
let isCurrentEntry = router.isDisplaying(entry)
await router.hide(animated: false)
```

`fullScreenEntry` and `partialEntry` expose the current presentation entries.
`isPresentingSheet` and `presentedSheetType` reflect those bindings. They become
false/nil when dismissal begins, before its animation finishes.

Attach `sheetRouterView(_:makeView:)` or the standalone `router.view(makeView:)`
so SwiftUI can deliver the dismissal callbacks that queued actions await. Use one
presentation host per single-sheet router.

See [SheetRouterDemo](Sources/SwiftRouting/Routers/Sheets/SheetRouter/SheetRouterDemo.swift).

### Stacked sheets

```swift
@MainActor
struct StackedSheetsExample: View {
    @StateObject private var router = SheetsRouter<AppRoute>()

    var body: some View {
        Button("Show detail") { router.show(.detail(42)) }
            .sheetsRouterView(router) { route in
                destination(for: route)
            }
    }
}
```

- `show(_:sheetType:animated:onDismiss:)` adds a presentation above the current stack.
- `replace(_:sheetType:animated:onDismiss:)` dismisses the top sheet, waits for its
  callback, then presents a replacement. With an empty stack, it behaves like `show`.
- `hide(animated:)` dismisses the top sheet.
- `hide(index:animated:)` dismisses the sheet at a zero-based position from the
  bottom, along with every sheet above it. Invalid indices do nothing.
- `hide(entry:animated:)` dismisses an exact occurrence and every sheet above it.
  Entries from another router or an earlier presentation do nothing.
- `hideAll(animated:)` dismisses all sheets.

Stack actions enter only the `SheetsRouter` queue. Its child presenters run their
internal presentation methods directly; standalone `SheetRouter` actions use their
own queue. Dismissal runs from top to bottom and waits for each callback. Presentation actions
return after assigning their entries, before their presentation animations finish.
The async `show` and `replace` overloads return an optional entry; nil means the
router was unavailable when its queued action ran. Synchronous overloads schedule
a task and return immediately. Attach a stacked-sheet host to deliver callbacks.

See [SheetsRouterDemo](Sources/SwiftRouting/Routers/Sheets/SheetsRouter/SheetsRouterDemo.swift).

### Tabs

```swift
@MainActor
struct TabsExample: View {
    @StateObject private var router = TabRouter<AppRoute>(tabs: [.home, .settings])

    var body: some View {
        router.view { route in
            destination(for: route)
        } makeLabel: { route in
            switch route {
            case .home: Label("Home", systemImage: "house")
            case .settings: Label("Settings", systemImage: "gearshape")
            case .detail: Label("Detail", systemImage: "info.circle")
            }
        }
    }
}
```

`tabs` contains stable entries in display order. `selection` changes when the user
taps a tab or when you call `select(_:animated:)` or `select(index:animated:)`.
Select by route to choose its first occurrence, or by entry/index to choose an
exact occurrence. Unknown routes, foreign entries, and invalid indices do nothing.

The initializer accepts `selected:`. Nil or an unknown route selects the first
entry. An empty collection has nil selection. Tabs are fixed after initialization.

See [TabRouterDemo](Sources/SwiftRouting/Routers/Tab/TabRouterDemo.swift).

### Pages

```swift
@MainActor
struct PagesExample: View {
    @StateObject private var router = PageRouter<AppRoute>(pages: [.home, .settings])

    var body: some View {
        router.view(indexDisplayMode: .never) { route in
            destination(for: route)
        }
    }
}
```

`pages` contains stable entries in display order. Swipes and programmatic selection
update `selection`. Selection follows the same rules as `TabRouter`, including
`selected:`, empty collections, repeated routes, and invalid requests.

`next(animated:)` and `previous(animated:)` move one page and stop at the ends.
Page indicators use `.automatic` by default; `indexDisplayMode:` also accepts
`.always` and `.never`. An empty page collection renders no pager.

See [PageRouterDemo](Sources/SwiftRouting/Routers/Page/PageRouterDemo.swift).

## Ownership and animation

Keep coordinators and view models out of route values where possible. A router
retains its routes and active dismissal callbacks. If a callback captures the
coordinator that owns the router, use a weak capture when needed to avoid a cycle.
View builders should construct destination views without mutating router state.

`animated: false` disables animations in the update transaction. `animated: true`
allows the enclosing animation or SwiftUI presentation system to animate; it does
not supply a custom animation curve.

`SerialQueue` executes async main-actor operations one at a time. An operation must
not await another operation on the same queue, since the nested operation cannot
start until the current one completes.
