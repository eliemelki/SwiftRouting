# SwiftRouting SDK for iOS Change Log

All notable changes to this project are documented here.
This project follows [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-10-05

This release changes the public routing API. See the [1.x migration guide](MIGRATION.md).
Requires Swift 6 and iOS 16 or later.

### Added

- Typed `Route` values and `RouteEntry<T>` identities for repeated destinations.
- `StateRouter<T>` for replacing the current destination without navigation history.
- `TabRouter<T>` and `PageRouter<T>` with programmatic selection and typed view builders.
- Navigation `push` returns an entry; `pop(entry:)` removes a specific occurrence
  and its successors, while `pop(to:)` keeps the target occurrence.
- `dynamicSheetSize()` for content-sized, scrollable partial sheets on iOS 16+.
- A separate LB SMART bank demo with login, independent tab navigation, card paging,
  account details, and expandable profile sheets using View → ViewModel → Coordinator.
- Tests for queue ordering, route identities, sheet dismissal, state replacement,
  tab/page selection, bank flows, ownership, and rendered sheet sizing.

### Changed

- Routers are generic over a `Hashable & Sendable` route and isolated to the main actor.
  Destination views are supplied through typed builders instead of view erasure.
- Router hosts use `view(...)`; sheet hosts also support view modifiers with builders.
- Rename `SheetsRouter` to `StackSheetsRouter` and its view modifier to `stackSheetsRouterView(...)`.
- Navigation state is named `root` and `path`, with `setRoot(_:)` replacing `setMain(_:)`.
- Sheet presentation state uses `fullScreenEntry` and `partialEntry`.
  Queries use `isPresentingSheet` and `presentedSheetType`.
- Single-sheet dismissal callbacks use `onDismiss` instead of `dismissHandler`.
  Stacked sheets use `hide(entry:)` instead of `hide(routable:)`.
- Stacked sheet actions are serialized once. Multi-sheet dismissal uses one subtree
  dismissal transition, then delivers callbacks sequentially from top to bottom.
- `SerialQueue` runs async main-actor operations in order without nested task scheduling.

### Removed

- The `Routable`, `RoutableFactory`, and `ViewFactory` APIs, erased route wrappers,
  router `createView()` methods, and `HashableByType` helper.
- The public `SheetsActions` protocol and redundant internal action protocols.
- Unused collection, task-waiting, test-detection, and publisher-tracking helpers.

## [1.0.1] - 2025-05-22
### Fixed
- Prevent a crash when popping an empty navigation path.

### Added
- Add navigation router tests.


## [1.0.0] - 2025-05-22
### Initial Release
