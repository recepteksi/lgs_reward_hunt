# Regressions — the class of each mistake, and what now catches it

Git records every fix; this records the lesson. One row per CLASS of mistake,
per CLAUDE.md rule 11: a test that fails without the fix, a mechanical guard
where one is possible (`check_structure` or a lint beats a written rule), and a
row here. Delete a row when it stops teaching anything.

| Class | What happened | Guard |
|---|---|---|
| Wiring that never runs | The mock backend was written but `initMock` was never called from `main`. | `test/support/mock_backend.dart` installs it the way `main` does; flow tests go through it. |
| Date rules on the wrong year | The countdown used this year's exam after it had passed. | `test/infrastructure/exam/exam_schedule_test.dart`; `nextExamAfter(moment)` takes the clock. |
| A session missing a half | Email sign-in saved the parent without the first child; the app reopened on setup. | `OpenSessionUseCase` is the one way a session is opened; `sign_in_flow_test.dart`. |
| Creation rules applied to existing data | Sign-in held the password to new-password rules and refused the demo account. | `PasswordValueObject` vs `EnteredPasswordValueObject`; `sign_in_flow_test.dart`. |
| Layout that only fits a big phone | Task setup and the top bar overflowed; the map sheet sat under the nav bar; the PIN page overflowed by 139 px at 360×640. | `check_structure`: every page has a test pumping a phone ≤ 360 wide (`pumpPage`); `AppFillScrollView` for fill-or-scroll bodies. |
| Pages nobody tested | Four auth pages had no test at all. | `check_structure`: a page without a test fails. |
| A test that passes the wrong way | A tap on a button scrolled out of view only warned, and the test failed later for an unrelated-looking reason. | `test/flutter_test_config.dart` makes a missed tap fatal. |
| A state change with no feedback | Deciding a redemption emitted no notice, so no toast. | `parent_page_test.dart` asserts the toast. |
| Debug output left behind | A `print` stayed in a test. | `avoid_print` lint. |
| Stale doc references | Moves renamed types; `[OldName]` in docs pointed at nothing. | `comment_references` lint. |
| Values without equality | Thirty domain types claimed value semantics and had no `==`. | `BaseEntity` / `BaseValueObject` / `BaseReadModel`; `check_structure` requires the base; `test/core/base/domain_bases_test.dart`. |
| Dead code by copy-paste | Request DTOs generated a `fromJson` nothing may call. | `check_structure`: `createFactory: false`, no `fromJson`. |
| Helpers hiding beside a class | Entity mappers were public functions in repository files. | `check_structure`: rule 1 and the `toEntity()` rule. |
| Getting around the composition root | `App` read `getIt` itself. | `check_structure`: rule 9. |
| Leftovers after a move | Empty folders, a stray enum in a Cubit folder, unused copy keys. | `check_structure`: empty folders, cubit folder contents, unused arb keys. |
| Platform wiring undone or missing | Flavor build configs had no signing team; Android had no SHA-1 client; a full flavorizr run would drop Firebase settings. | `check_structure` native rules (xcconfig ↔ GoogleService-Info ↔ flavorizr, entitlements, Android OAuth client). |
| An OS file read as source | `.DS_Store` failed the folder check. | Dot files are skipped by the checker. |
| A frame rebuilt on every tab switch | Each child tab was its own route with its own navigation bar, so switching tabs rebuilt the screen and flashed a loading page with no bars. | Tabs are branches of one `StatefulShellRoute` (`AppChildShell`), preloaded and kept alive, refreshed quietly through `AppTabRefresh`, swiped between in `AppTabPager` with each page kept alive (`AppKeepAlivePage`); `test/presentation/router/app_child_shell_test.dart`. |
| A loading state that drops the frame | Tabs loaded into a bare `AppScaffold(body: AppLoadingView())`, so the app bar vanished and the profile made a known child wait. | `check_structure` (rule 23): a `*Loading` state never maps to `AppLoadingView`; loading states carry the child snapshot; `profile_page_test.dart` opens a known child at once. |
