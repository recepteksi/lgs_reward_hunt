# Build log

**History.** Every slice as it was built, with the decisions taken on the way.
The live plan — what is open — is [BUILD-PLAN.md](../BUILD-PLAN.md). Read this
only when a decision needs its reason.

The app, in slices. Each one is a vertical cut — domain, mock service, use
case, Cubit, page — that leaves the four-step gate green, so any slice is a
place to stop and any slice is a place to resume.

**Resuming in a new session:** read [CLAUDE.md](../CLAUDE.md) (the rules),
[PROJECT-MAP.md](../PROJECT-MAP.md) (where things live), then this file. Take the
first slice that is not ticked and work only that one.

## The source of truth

The design is the Claude Design project **LGS Reward Hunt Details**,
`9adc491c-8580-4bf3-a6bf-81f2c80b24ba`, read with the `DesignSync` tool:

| File | What it is |
|---|---|
| `LGS Ödül Avı.dc.html` | the twelve screens, with the flows in its `DCLogic` script |
| `LGS Ödül Avı UI Kit.dc.html` | the eleven component sections |
| `avatars.json` | the avatar catalogue the setup screen fetches |

The older design-system project `7f80d0df-…` is the PREVIOUS direction
(Bricolage + amber) and is not authoritative. Where the two disagree, the canvas
wins.

Pages are named in English everywhere — in the code (`IntroPage` in
`presentation/auth/pages/intro/`), in this plan and in the design's screen picker (`Intro`, `Sign up`, … `Parent`). Only what a user reads
is Turkish.

The screens artboard is large; save it to a file and grep it rather than reading
it whole. Its `state = {…}` block and its methods (`finishAuth`, `commitPin`,
`finishSetup`, `toggleTask`, `request`, `decide`, `switchKid`, `loadAvatars`)
are the specification for the flows.

## The gate — after every slice

```bash
flutter analyze
dart run tool/check_structure.dart
flutter test
```

Nothing is committed or pushed until the user asks.

---

## ✅ Slice 0 — Foundation

Layers, DI, router, flavors, l10n (Turkish only, locale pinned), theme built
from five accents, the bundled Nunito, `AppText` / `AppScaffold` / `AppButton`
and the rest of `presentation/base/ui/widgets/`, the temporary `/ui-kit` sheet,
the constants taxonomy and the two `tool/` checkers.

## ✅ Slice 1 — Identity, session, avatars (mock)

`CredentialsValueObject` · `ParentPinValueObject` · `SessionValueObject` · `AvatarEntity` +
`AvatarStyleEnum` · three ports · `AuthRepository` (`/auth/sign-up`,
`/auth/sign-in`, `/parents/{id}/pin`, `…/pin/verify`) · `AvatarRepository`
(`/avatars`) · `SessionRepository` (shared_preferences) · seven use cases.
Demo account in `assets/mock/demo_household.json`: `ayse@ornek.com` /
`lgs12345`, PIN `1234`.

## ✅ Slice 1b — Appearance

`AccentChoiceEnum` · `ThemeChoiceEnum` · `AppearanceSettingsValueObject` ·
`AppearanceRepository` · `AppearanceCubit` (the one shell-level Cubit,
`lazySingleton`, restored in `main` before the first frame).

---

## ✅ Slice 1c — DTOs and the crypto seam

`BaseRequest` / `BaseResponse` in `infrastructure/network/dto/`, sixteen `json_serializable`
DTOs under `infrastructure/<feature>/dto/`, every repository converted, and
`PayloadCodecInterface` + `CryptoInterceptor` as the place encryption will plug
in (`PassthroughPayloadCodec` today, `PayloadEnvelopeDto` is the wire format it
will produce).

## ✅ Slice 1d — The mock backend, split

`MockRouter` is a thin route table over each feature's `infrastructure/<feature>/mock/` handler — avatar, auth,
account, task, task plan, reward, points — each listing its own endpoints and
holding its rules. Content lives in `assets/mock/*.json` (avatars, the standard
task plan and reward pool, the demo household) and `MockSeed` loads it;
`DioClient.initMock` is async. `main` now installs the mock while
`AppConfig.useMockBackend` is on — before this, nothing did, and a device build
sent every request to a host that does not exist. Tests build it through
`test/support/mock_backend.dart`.

## ✅ Slice 2 — Onboarding, seven pages

Design pages: `Intro · Sign up · Password · Parent PIN · Child setup ·
Task setup · Reward setup`. Each step is its own route, so a parent who
kills the app halfway comes back to the step they were on.

- [x] `AppTextField` and `AppSetupHeader` in the kit — the six steps share both.
- [x] **Sign up** — `AuthPage` + `AuthCubit`. Sign-in finishes here (session
      written, straight to the map); sign-up carries the name and email forward
      in a `PasswordArgumentsModel`.
- [x] **Password** — `PasswordPage` + `PasswordCubit`. Creates the account and
      writes the session. The checklist renders `PasswordRuleEnum`, the same
      three rules `CredentialsValueObject` refuses a password on.
- [x] **Parent PIN** — `ParentPinPage` + `ParentPinCubit`. Two passes, one
      keypad; a mismatch restarts rather than asking for a correction to a code
      nobody can see.
- [x] `main` picks the first route from the stored session.
- [x] **Intro** — `IntroPage`, three slides (`IntroSlideEnum`) in a
      `PageView` with the segment indicator and a skip. No Cubit: no use case
      behind it. The slide pictures are built from the real kit widgets
      (`AppTaskRow`, `AppProgressRing`, `AppStatusBadge`). A device with no
      session now opens here instead of on the account step.
- [x] Google and Apple buttons, through **Firebase Auth** (project
      `lgs-reward-hunt`, one Firebase app per flavor —
      `infrastructure/config/firebase/firebase_options_{dev,prod}.dart`,
      `android/app/src/<flavor>/google-services.json`,
      `ios/config/<flavor>/GoogleService-Info.plist`). `FirebasePlatformSignInService`
      (`PlatformSignInInterface`) gets the provider's ID token;
      `PlatformSignInUseCase` hands it to `POST /auth/platform`, which finds the
      parent by email or opens a new account (`isNewAccount`). A new account goes
      to the parent PIN; a returning one to home or child setup. Apple shows on
      iOS/macOS only. A cancelled sheet is not an error — the form comes back.
      Wired: `AppConfig.googleServerClientId` is the project's web client;
      each flavor's iOS client and URL scheme come from
      `ios/Flutter/<flavor><Config>.xcconfig` (`GOOGLE_CLIENT_ID`,
      `GOOGLE_REVERSED_CLIENT_ID`, also in flavorizr `buildSettings`) into
      `Info.plist`; `Runner.entitlements` carries Sign in with Apple; the
      debug SHA-1 is registered on both Android apps. **Before a release:**
      add the release keystore's SHA-1 in Firebase and refresh
      `google-services.json`; enable the Sign in with Apple capability on both
      App IDs in Apple Developer.
      Email sign-in no longer applies the new-password rules
      (`CredentialsValueObject.existing`) — they refused the demo account.
- [x] **Child setup** — two pages. `ChildSetupPage` + `ChildSetupCubit`: the
      parent's card, the children with their faces, remove, and the
      `AccountRules.maxChildren` limit (`HouseholdReadModel`). `ChildFormPage` +
      `ChildFormCubit`: name, grade, the girl/boy catalogue tabs and the
      avatar grid with its loading / error / retry states; saving builds a
      `ChildProfileValueObject` and the first child becomes the session's. New
      endpoints: `GET /parents/{id}`, `GET /parents/{id}/children`,
      `DELETE /children/{id}`. `AppAvatar` draws a face from `AvatarEntity`.
      The PIN step now leads here, and `main` reopens here for a parent with
      no child yet. Continue goes to the map until Task setup exists.
- [x] **Task setup** — `TaskSetupPage` + `TaskSetupCubit`. Opens on the
      parent's saved plan or the standard day (`GET /task-plans/standard`, the
      design's `STD_TASKS`); each line expands into kind / category / topic /
      time / duration / points / repeat. Domain: `TaskKindEnum`,
      `TaskCategoryEnum` (lessons and chores, the design's lists),
      `TaskRepeatEnum.occursOn`, `TaskTemplateEntity`, `TaskPlanValueObject`,
      `TaskPlanRules`. Saving (`PUT /parents/{id}/task-plan`) writes every
      child `TaskPlanRules.horizonDays` of tasks and replaces unfinished future
      ones on a re-save. `AppDashedAddButton` and `AppOptionTile` moved to
      `base/`. Child setup now leads here; saving goes to the map until Reward
      setup exists. `main` does not yet reopen on this step.
- [x] **Reward setup** — `RewardSetupPage` + `RewardSetupCubit`. Opens on the
      parent's active rewards or the suggested pool
      (`GET /reward-pools/standard`, the design's `STD_REW`); each reward
      expands into name / category / cost. Domain: `RewardCategoryEnum` (now
      on `RewardEntity` too), `RewardDraftEntity`, `RewardPoolValueObject`,
      `RewardPoolRules`, and `DraftRules` shared with the task plan.
      Saving (`PUT /parents/{id}/reward-pool`) creates new rewards, updates
      kept ones and retires — never deletes — the ones left out, then ends
      setup on the map. The design's closing toast ("Kurulum tamam · N görev, M ödül hazır") shows as it leaves.
- [x] The multi-child step — `DeviceChildPage` + `DeviceChildCubit`, after
      reward setup. `DeviceChoiceReadModel` (household, balances, the
      device's child); with one child the Cubit chooses it without asking, with
      two each row shows grade and balance and a tap stores
      `ChooseDeviceChildUseCase`'s choice and opens the map.

## ✅ Slice 3 — The map, the home page

Design page: `Map`.

- Domain: `StudyStopReadModel` (a day and its tasks; passed / today /
  upcoming, special = a practice exam on it, complete, earned, total) and
  `StudyPathReadModel` (from `StudyMapRules.stopsBeforeToday` days back,
  `visibleStops` long or to the exam; today, walked stops, zones, days past the
  end), `StudyMapReadModel` for the page. `LoadStudyMapUseCase` reads it in
  one go, including `GET /children/{id}/tasks?from&to` — the range endpoint the
  path needed instead of 44 requests. `CompleteTaskUseCase` ticks a task.
- `HomeCubit` is now the map's (loading / failed / ready / completing /
  complete failed); the old countdown body is gone.
- `HomePage`: the road is `HomeTrailPainter` (locked road, walked road, dashed
  road to the exam, seeded terrain) over `HomeMapGeometry`'s layout; stops are
  the kit's `AppMapStop` via `HomeMapStopItem`; zone dividers, the exam flag
  and the "stops ahead" chip sit on it. `AppAppBar.overlay` floats the child
  pill and the points pill (with the rising "+NP") over the full-bleed map;
  `AppScaffold.extendBehindAppBar` is new. The day sheet is a
  `DraggableScrollableSheet` that stops above the navigation bar.
- **Fixed on the way:** `ExamScheduleRepository` answered this calendar year's
  exam, which in September is already past; it is now `nextExamAfter(moment)`,
  with the test that catches it.
- The demo household now saves the standard plan plus a weekend practice exam,
  so the map has a fortnight of real stops.
- Differences from the prototype, on purpose: a stop's label sits under it
  (the kit stop), not beside it; a passed day that was not finished keeps its
  number and shows how far it got rather than being ticked; a ticked task
  cannot be un-ticked, because its points were paid. The navigation bar's other
  tabs and the parent button are inert until slices 4–7 give them pages.

## ✅ Slice 4 — Rewards

Design page: `Rewards`.

- `RewardShopReadModel` gained the shop's rules: `offered` (active, cheapest
  first), `offeredIn(category)`, `stateOf` → `RewardOfferStateEnum`
  (available / locked / pending, a pending request blocks asking again),
  `progressFor`, `cheapestOffered`, `requestsNewestFirst`.
- `LoadChildHeaderUseCase` (+ `ChildHeaderReadModel`) is whose tab it is;
  `RequestRewardUseCase` asks for a reward (the existing redeem endpoint
  already holds the points and lists pending requests from the child's side).
- `RewardsPage` + `RewardsCubit`: the reward-coloured balance card, category
  chips, a two-column grid of `AppRewardCard`, "İsteklerim" with the kit's
  status badges and the parent's note, and a toast once a request is sent.
- The floating pills moved to the kit as `AppChildPill` and `AppBalancePill`.
  Tabs route through `AppRoutePaths.tab`; home and rewards are
  `NoTransitionPage`s. Progress and profile tabs stay inert until 5 and 6.
- The demo household gained an 80-point treat so its shop opens with one
  reward ready, as the design does.

## ✅ Slice 5 — Progress

Design page: `Progress`.

- `ProgressReadModel` holds the rules: level from points ever earned
  (`ProgressRules.pointsPerLevel`, so spending never demotes) with its
  `LevelRankEnum` name; a streak that counts finished days back from today,
  where an unfinished today does not break it and a day with nothing planned
  neither counts nor breaks; this week's done tasks Monday first; this month's
  days as `ProgressDayStatusEnum`; `AchievementEnum` badges (a week's streak,
  a first practice exam, ten of them) with their progress.
- The prototype derived the level from the balance; that would drop a child a
  level for buying a reward, so it uses `earnedTotal` instead.
- `LoadProgressUseCase` reads the ledger and `ProgressRules.historyDays` of
  tasks through the range endpoint. `ProgressPage` + `ProgressCubit`:
  `AppLevelCard`, two stat tiles, `AppWeekChart`, the month strip and the
  badges.
- `AppChildNavigation` is the kit's bar wired to the tab routes, and the one
  type `AppScaffold.bottomNavigationBar` takes; home, rewards and progress all
  use it. The profile tab and the parent button stay inert until 6 and 7.

## ✅ Slice 6 — Profile

Design page: `Profile`.

- `ProfilePage` + `ProfileCubit` over `LoadProfileUseCase`, which reuses the
  header and progress use cases (so the level and streak are the progress
  tab's) and adds the linked parent and the next exam
  (`ProfileReadModel`).
- The child's card on the primary colour, three figures (balance, streak,
  tasks), the appearance card — the kit sheet's bar, now `AppAppearancePicker`
  in the kit, reading and writing `AppearanceCubit` from `App` — and the
  settings list: parent mode, exam date, linked parent.
- `AppTheme.choiceFrom` and `AppAccentEnum.choice` translate a picked value
  back to the stored setting.
- Left out of the design on purpose: the reminders row (no reminder exists
  behind it) and the fruit illustrations on the accent swatches (the kit's
  plain swatches stand in). Switching children lives on the parent page, where
  the design puts it, so it moves to Slice 7. The parent mode row opens the
  parent side once Slice 7 builds it.

## ✅ Slice 7 — Parent

Design page: `Parent`.

- **The gate:** `ParentGatePage` + `ParentGateCubit` over
  `VerifyParentPinUseCase`, opened by the navigation bar's parent button and
  the profile's parent mode row; the fourth digit checks, a wrong code clears
  (`FailureMessageKey.pinWrong`), the right one replaces the gate with the
  parent page. `AppPinDots` and `AppPinKeypad` moved to the kit.
- **The page:** `ParentPage` + `ParentCubit` over
  `LoadParentDashboardUseCase` (`ParentDashboardReadModel`: household, the
  device's child with balance and streak, pending requests, the pool, the
  week's tasks, the exam, the suggested rewards). No navigation bar; "Çık"
  returns to the profile.
- **Approvals tab:** the child switch for a household of two
  (`ChooseDeviceChildUseCase`), the child's day card, each pending request with
  "Şimdi olmaz" / "Onayla" (`DecideRedemptionUseCase`), then a seven-day strip
  (`ParentRules.dayStripDays`) and that day's tasks. A task opens
  `ParentTaskSheet` (the kit's `AppTaskTemplateEditor`, moved from setup): a
  new one can repeat until `TaskSeriesEndEnum` (1 / 2 / 4 weeks, until the
  exam) via `AddTaskSeriesUseCase`; an existing one is saved or removed
  (`UpdateTaskUseCase`, `DeleteTaskUseCase`). A finished task cannot be
  edited.
- **Pool tab:** the new-reward form, the suggested rewards as one-tap chips,
  and every reward with `AppToggle` (new in the kit), a price stepper
  (`RewardPoolRules.costStep`) and "Kaldır" — `AddRewardUseCase`,
  `UpdateRewardUseCase`, `RemoveRewardUseCase`.
- **Endpoints added:** `POST /children/{id}/tasks/series`,
  `PUT` / `DELETE /tasks/{id}` (refused for a finished task),
  `PATCH /rewards/{id}`, `DELETE /rewards/{id}` (a reward somebody asked for
  is kept for their history and stops being listed).

## ✅ Slice 8 — Splash, transitions, polish

- [x] The launch screen and the flavor icons. Art is the **"LGS Ödül Avı
      Brand"** page in the Design project: a trail from a ticked stop to a
      starred reward coin on the blue accent; dev adds a DEV band. Sources are
      `assets/brand/` (1024 icons, adaptive foreground/background with the mark
      fitted to the 66dp safe zone, splash and Android 12 splash). Icons come
      from flavorizr's `icon` / `adaptiveIcon` keys, generated with
      `dart run flutter_flavorizr -p android:icons,ios:icons` (only those two
      steps — a full `-f` run would rewrite the Firebase wiring). The launch
      screen is `flutter_native_splash.yaml` (`dart run
      flutter_native_splash:create`), shared by both flavors: blue ground, a
      night-blue one in dark mode.
- [x] Toasts: `AppToastPresenter` shows the kit's `AppToast` the one way the
      app does (the rewards request, and the parent's approvals, rejections,
      new rewards and task edits through `ParentDone` / `ParentNoticeEnum`).
      The points-earned animation is `AppBalancePill`'s rising "+NP" (Slice 3).
- [x] Transitions: `AppTheme.pageTransitionsTheme` pins a forward fade on
      Android and the native slide on iOS; the child tabs switch without one.
- [x] `/ui-kit` is **kept**, not deleted: it is debug-only (`kDebugMode`),
      linked from nowhere in the product, and rule 15 still has every new kit
      widget land on it — this slice added `AppToastPresenter`, the last one
      added `AppPinDots`, `AppPinKeypad`, `AppToggle` and
      `AppTaskTemplateEditor`. Shrink it when the kit stops changing.

---
