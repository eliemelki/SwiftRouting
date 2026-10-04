
# SwiftRouting SDK for iOS Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

### Changed

- Document typed routes, occurrence identity, and all five routers.
- Standardize router view factories as `view(...)` and dismissal callbacks as `onDismiss`.
- Rename navigation state to `root` and `path`, with `setRoot(_:)` for root updates.
- Rename sheet state to `fullScreenEntry` and `partialEntry`; expose `isPresentingSheet`
  and `presentedSheetType` queries and use `hide(entry:animated:)` for exact occurrences.

### Removed

- Unused collection, task-waiting, test-detection, and publisher-tracking helpers.
- Redundant internal action protocols and unused navigation demo state.

### Added

- Typed tab and page routers with programmatic selection and demos.

## [1.0.1] - 2025-05-22
### Fixed
- Prevent a crash when popping an empty navigation path.

### Added
- Add navigation router tests.


## [1.0.0] - 2025-05-22
### Initial Release
