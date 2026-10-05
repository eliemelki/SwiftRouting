
# SwiftRouting SDK for iOS Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

### Changed

- Use `Coordinator` protocol names and consolidate the bank root presentation into the BankApp feature.

- Decouple bank view models through screen-specific coordinator protocols and typed host protocols.

- Return navigation entries from `push` and support popping an exact occurrence or returning to it.

- Dismiss a sheet subtree in one transition, then deliver callbacks once from top to bottom.

- Serialize stacked sheet actions once, using the stack queue and direct child presentation methods.

- Document typed routes, occurrence identity, and all five routers.
- Standardize router view factories as `view(...)` and dismissal callbacks as `onDismiss`.
- Rename navigation state to `root` and `path`, with `setRoot(_:)` for root updates.
- Rename sheet state to `fullScreenEntry` and `partialEntry`; expose `isPresentingSheet`
  and `presentedSheetType` queries and use `hide(entry:animated:)` for exact occurrences.

### Removed

- Unused collection, task-waiting, test-detection, and publisher-tracking helpers.
- Redundant internal action protocols and unused navigation demo state.

### Added

- `dynamicSheetSize()` for content-sized, scrollable partial-sheet destinations on iOS 16+.
- A standalone `LBSmart.xcodeproj` bank demo branded LB SMART, with expandable content-sized profile sheets.

- A sample bank app using a View → ViewModel → Coordinator flow, with login, independent tab navigation, card paging, account details, and profile sheets.

- Typed tab and page routers with programmatic selection and demos.

## [1.0.1] - 2025-05-22
### Fixed
- Prevent a crash when popping an empty navigation path.

### Added
- Add navigation router tests.


## [1.0.0] - 2025-05-22
### Initial Release
