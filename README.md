# SwiftRouting

SwiftRouting separates SwiftUI destination views from the code that decides when
to navigate, present a sheet, switch tabs, change pages, or replace the current view. It supports iOS 16 and
later and uses Swift 6.

## Installation

Add `https://github.com/eliemelki/SwiftRouting.git` in Xcode's package dependencies
and choose version **2.0.0** or later within the 2.x major version.

```swift
.package(url: "https://github.com/eliemelki/SwiftRouting.git", from: "2.0.0")
```

For upgrades from 1.x, follow the [migration guide](MIGRATION.md).
See the [changelog](CHANGELOG.md) for release details.

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
| `StateRouter<T>` | One current destination, replaced without navigation history. |
| `NavigationRouter<T>` | A root destination with a stack of pushed entries. |
| `SheetRouter<T>` | One partial sheet or full-screen cover; showing another replaces it. |
| `StackSheetsRouter<T>` | A stack of partial sheets and full-screen covers. |
| `TabRouter<T>` | A fixed collection of tabs with a selected entry. |
| `PageRouter<T>` | A fixed collection of swipeable pages with a selected entry. |

All six routers expose `view(...)` to build a host view. Sheet routers also have
view modifiers for attaching their presenters to existing content.

### State replacement

```swift
@MainActor
struct StateExample: View {
    @StateObject private var router = StateRouter<AppRoute>(route: .home)

    var body: some View {
        router.view { route in
            destination(for: route)
        }
    }

    private func showSettings() {
        router.set(.settings)
    }
}
```

`set(_:)` replaces the destination without a stack or queue. Setting the same route
is a no-op. Changing routes resets the destination's local view state. The router
handles presentation; coordinators manage session creation and cleanup.

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
- `push(_:animated:)` appends and returns a new occurrence, even when the route repeats.
- `pop(entry:animated:)` removes that exact entry and everything pushed after it.
- `pop(to:animated:)` keeps that exact entry and removes everything pushed after it.
  An entry absent from the current path does nothing.
- `popLast(animated:)` removes the last entry; an empty path is unchanged.
- `popToRoot(animated:)` removes every pushed entry.
- `setRoot(_:)` replaces the root while preserving the path. Call `popToRoot()`
  separately when you also want to clear the stack.

```swift
// In a main-actor coordinator:
let detail = router.push(.detail(42))
router.push(.settings)
router.pop(to: detail) // Displays detail(42), keeping its entry.
router.pop(entry: detail) // Removes detail(42), returning to the root.
```

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

### Content-sized sheets

Apply `dynamicSheetSize()` to a partial sheet's destination to measure its ideal
content height and update its detent whenever that height changes:

```swift
.sheetRouterView(router) { route in
    VStack(alignment: .leading, spacing: 16) {
        Text("Information").font(.headline)
        Text("Content can grow, shrink, or wrap as the available width changes.")
    }
    .padding(24)
    .dynamicSheetSize()
}
```

This is an opt-in destination modifier, so it works with both single and stacked
sheet routers without changing routing APIs. It supports iOS 16+, uses SwiftUI's
[height detents](https://developer.apple.com/documentation/swiftui/presentationdetent),
and places the content in a vertical scroll view for accessibility when it exceeds
the available sheet height. The system adds its presentation safe areas.

Use intrinsically sized content. Avoid an expanding `Spacer`, a `List`, or a nested
`ScrollView`, and include desired padding before the modifier. Do not combine it
with another `presentationDetents` modifier. A large detent is used for the first
layout until the content's height can be measured. Full-screen covers do not use detents.

LB SMART's **Profile → Security** and **Profile → Privacy** links use this modifier.
Tap **Learn more** or **Show less** to change their content and sheet height.
**Support** keeps standard medium/large detents for comparison.

### Stacked sheets

```swift
@MainActor
struct StackedSheetsExample: View {
    @StateObject private var router = StackSheetsRouter<AppRoute>()

    var body: some View {
        Button("Show detail") { router.show(.detail(42)) }
            .stackSheetsRouterView(router) { route in
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

Stack actions enter only the `StackSheetsRouter` queue. Its child presenters run their
internal presentation methods directly; standalone `SheetRouter` actions use their
own queue. Hiding multiple sheets dismisses the lowest targeted presenter and
its subtree in one transition. After that presenter completes dismissal, the
router delivers each dismissal handler once, sequentially from top to bottom. Presentation actions
return after assigning their entries, before their presentation animations finish.
The async `show` and `replace` overloads return an optional entry; nil means the
router was unavailable when its queued action ran. Synchronous overloads schedule
a task and return immediately. Attach a stacked-sheet host to deliver callbacks.

See [StackSheetsRouterDemo](Sources/SwiftRouting/Routers/Sheets/StackSheetsRouter/StackSheetsRouterDemo.swift).

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

## Bank demo app

Open `LBSmart/LBSmart.xcodeproj` and run the `LBSmart` scheme.
The separate `Demo/Demo.xcodeproj` remains the individual-router showcase. The app launches at a
sample login screen. Tap **Sign in to demo** to enter LB SMART; no credentials
or network services are involved.

Every bank screen has its own view model. Views own their models with `@StateObject`,
view models depend on focused coordinator protocols, and the existing coordinator
implementations create routers and build destinations.
View actions call view-model methods, which delegate navigation to coordinators.
Demo types and cross-file methods have module-internal access; view-model storage,
implementation-only dependencies, and parent references are private. The package's
consumer APIs remain public.

- **Accounts:** a navigation stack listing sample accounts and their detail screens.
- **Cards:** an independent navigation stack containing a `PageRouter` of cards.
  Each card opens its linked account in the Cards stack using the same account-detail
  view and view model as Accounts.
- **Profile:** an independent navigation stack for personal details, with security,
  privacy, and support links presented through `SheetRouter`.
- **Sign out:** returns to login and releases the session. Signing in again creates
  fresh tabs, navigation paths, and pager state.

`BankAppCoordinator` controls the login/signed-in root state. `BankTabsCoordinator`
owns `TabRouter` and the three tab coordinators. `AccountsCoordinator`,
`CardsNavigationCoordinator`, and `ProfileCoordinator` each own a `NavigationRouter`;
`CardsViewCoordinator` owns the card pager separately, and Profile owns its sheet
router. Only the tab hosts
create navigation stacks, avoiding a navigation stack wrapped around the tab bar.
Action-only models use protocols such as `LoginCoordinator`, `ProfileViewCoordinator`,
and `AccountDetailCoordinator`. The app, tab, and Cards container hosts use concrete
coordinators. The Cards view
and view model use `CardsViewCoordinator` directly, without generics or a container
protocol. Accounts and Profile retain their typed container protocols.
Each protocol lives in its own Swift file beside its screen or host.

`BankAppCoordinator` owns `StateRouter<BankAppRoute>` and switches between login
and the signed-in tabs. The router host observes state directly, so the app view
model only retains its coordinator. Coordinators do not conform to `ObservableObject`;
views observe their view models and routers.

Parent coordinator references are weak, so the session and child coordinators do
not retain each other in cycles. Destination view builders do not mutate router state.

The example is in [LBSmart/LBSmart/Bank](LBSmart/LBSmart/Bank). Flow tests cover sign-in/sign-out,
independent tab navigation, linked-account details, pager selection, profile routing,
session release, and rendered sheet expansion/collapse.

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
