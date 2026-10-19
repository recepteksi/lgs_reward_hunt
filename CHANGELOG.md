# Changelog

What changed in each version, newest first, in the words a tester would use.
The `## [Unreleased]

## [1.2.0] - 2026-10-19

### Added

- A "Sign out" button on the parent page, visible even when the page fails to load.

### Fixed

- After creating a new account and closing the app, the data was lost and every page showed an error. Test data is now kept on the device.
- When the profile failed to load, the theme setting and parent mode disappeared too. They now stay visible on an error.

### Changed

- The README, the changelog and all documentation are now in English; only the app's copy is Turkish.

## [1.1.0] - 2026-09-18

### Added

- In the dev flavor, a see-through test button on every screen: it shows the test accounts' email, password, PIN and link codes; tapping a row copies the value.
- Release notes come from this file: testers on Firebase and Play read the top version of `CHANGELOG.md`.

## [1.0.0] - 2026-09-18

The first internal test release.

### Added

- Map: one stop a day, a path that advances as tasks are done, and an exam countdown.
- Rewards: request rewards the family agreed on with the points earned; each request waits for a parent's approval.
- Progress: streak, weekly chart, monthly strip and badges.
- Profile: theme and colour, exam date, linked parent.
- Parent mode: PIN entry, task plan, reward pool, request approvals and task editing.
- Setup flow: intro, account, password, parent PIN, child, task and reward setup, device choice.
- Google and Apple sign-in (Firebase Auth).

### Notes

- In this version data is kept only on the device and resets when the app closes; there is no real server yet.
