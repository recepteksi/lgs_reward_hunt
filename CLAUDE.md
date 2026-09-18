# CLAUDE.md

**LGS Ödül Avı** — a parent-controlled task-and-reward app for students preparing
for the Turkish LGS exam: task → complete → earn points → choose a reward →
parent approves. Flutter · `lgs_reward_hunt` · `com.lgsrewardhunt.app`.

**Read before exploring:** [PROJECT-MAP.md](PROJECT-MAP.md) (generated, never
stale — cheaper than any `find`), then [BUILD-PLAN.md](BUILD-PLAN.md) for what is
open. The reasoning behind every rule is in [architecture.md](architecture.md);
past bug classes and their guards in [docs/regressions.md](docs/regressions.md);
slice history in [docs/build-log.md](docs/build-log.md) — open those only when a
decision needs its reason. Never read generated files (`*.g.dart`,
`*.config.dart`, `l10n/generated/`).

This repo is the **structural reference** for the Flutter projects here: a
shortcut taken here is copied five times.

## The gate — work is not done while any step is red

```bash
flutter analyze                    # lints, incl. comment_references, no_default_cases, avoid_print
dart run tool/check_structure.dart # every rule marked ⚙ below, the native wiring, a current map
flutter test
```

CI runs all three; `.githooks/pre-commit` runs the first two (enable per clone:
`git config core.hooksPath .githooks`). A rule marked ⚙ is enforced by
`check_structure` — its message names the rule, so a red line is its own fix.

## Architecture

`core` ← `domain` ← `application` ← `infrastructure`; `presentation` → application,
domain, core — never infrastructure. `main.dart` and `application/di/` are the
composition root. ⚙

**Folders: `lib/<layer>/<feature>/<kind>/`.** ⚙ One closed feature list in every
layer: `account · auth · avatar · exam · parent · points · profile · progress ·
reward · session · settings · study_path · task` (add a feature to this list and
to `tool/structure/conventions.dart` before creating its folder). No loose
files in a feature; each kind folder holds one suffix:

| Layer | Shared folders | Kind folders in a feature |
|---|---|---|
| core | `base/` `constants/` `failure/` `validators/` | — |
| domain | — | `entities/` `value_objects/` `read_models/` `enums/` `interfaces/` `rules/` `validators/` |
| application | `di/` | `use_cases/` `cubit/<page>/` |
| infrastructure | `config/` `network/` | `repositories/` `services/` `dto/` `mock/` |
| presentation | `base/` `router/` `debug/` | `pages/<page>/` |

Placement: a use case → the feature whose repository it touches; a read model of
several features → its own feature; a page and its Cubit → the same feature
(`home` → study_path); a mock handler → `infrastructure/<feature>/mock/`; tests
mirror lib (`test/<layer>/<feature>/`). ⚙

## Rules

1. **One public declaration per file, named after the file**, suffix on file
   and type (`task_status_enum.dart` → `TaskStatusEnum`). No private helper
   classes; exceptions: a `sealed` family, a `State`. ⚙
2. **Errors are values.** domain/application never throw; `Either<Failure, T>`
   (either_dart). A `Failure` carries a `messageKey`; `failureCopy` makes words.
3. **Ports** are `*Interface` in `interfaces/`, never a leading `I`. ⚙
4. **Domain types extend their base** (`core/base/`) and own their rules. ⚙
   `BaseEntity` — equal by `id`. `BaseValueObject<T>` (halleder's shape: `value`,
   `validators`, `valueObject`, `isValid`) — equal by value; a composite holds a
   record of part VOs and lists `ValidPartsValidator`. `BaseReadModel` — a
   snapshot of entities, equal by `props`. Validators: `BaseValueValidator<T>`,
   generic in `core/validators/`, a feature's own in `domain/<f>/validators/`.
5. **One Cubit per page**, `application/<f>/cubit/<page>/` = `<page>_cubit.dart`
   + `<page>_state.dart` (a `part`). Cubits orchestrate, never compute; cancel
   what they own in `close()`. ⚙
6. **State is `sealed`**, one variant per thing the page shows. ⚙
7. **No magic values; each kind has one home.** ⚙ Quantities → `core/constants/`
   (`ValueConstants`, `CharConstants`, `RadixConstants`, `DurationConstants`,
   `FailureMessageKey`); measurements → `base/ui/values/` (`AppSpacing`,
   `AppRadii`, `AppSizes`, `AppOpacity`, `AppTypography`); colours → `AppPalette`;
   rules → `domain/<f>/rules/*_rules.dart`; addresses → `AppRoutePaths`; a value
   one page reads → a private `static const`. A vocabulary is ONE enum with
   exhaustive switches (no `default:`, lint).
8. **All copy through `AppL10n`**; one `app_tr.arb`, Turkish only, ICU plurals;
   unused keys fail. ⚙
9. **`getIt` only in `main.dart`, `di/` and a page's `BlocProvider`.** ⚙
10. **Package imports everywhere** (lint).
11. **A bug fix ships a test that fails without it**, named after the symptom,
    plus a mechanical guard where one is possible and a row in
    `docs/regressions.md` naming the class. Every page has a test that pumps
    a 360-wide phone (`test/support/pump_page.dart`) ⚙; a tap that misses its
    widget fails the test (`test/flutter_test_config.dart`).
12. **`main.dart` is the composition root**; flavor values reach `App` as
    arguments via `AppConfig`, never `switch (AppConfig.flavor)` at a use site.
13. **Comments sit above a declaration, never inside it** — one `///` block,
    naming members as `[x]`; `[x]` must resolve (lint), else use backticks. ⚙
14. **A page is a folder**: `<page>_page.dart` (an `AppScaffold` + the state
    `switch`), exactly one `body/<page>_body.dart`, then `items/` `widgets/`
    `app_bar/` `modal_bottom_sheet/`; root files named `<page>_*`. Routes are
    `RoutePath`s in `AppRoutePaths`; route arguments are `*ArgumentsModel` in
    `router/arguments/`. Page names are English. ⚙
15. **Every `base/ui/widgets` widget is on the `/ui-kit` sheet** (debug-only;
    its strings are specimens). ⚙
16. **Requests and responses are DTOs** in `infrastructure/<f>/dto/`:
    `*RequestDto extends BaseRequest` with `createFactory: false`;
    `*ResponseDto extends BaseResponse` with `toEntity()`, the one mapper. DTOs
    never leave infrastructure. ⚙
17. **The app's own widgets**: `AppText`, `AppScaffold` (slots take only
    `AppAppBar` / `AppChildNavigation`), `AppIconButton`, `AppButton`. ⚙
18. **Used twice → `base/ui/widgets/<group>/`**, not before.
19. **No widget names a colour** — `AppPalette.of(context)`; the reward colour
    is the points economy only. ⚙
20. **Closed type scale**, Nunito bundled as one variable font.
21. **Code is English**; only copy is Turkish. ⚙
22. **A pressable sits on a solid edge** (`AppSizes.edgeDepth`), never
    `elevation:` on a page. ⚙
23. **Loading never empties a screen.** The app bar and navigation bar stay;
    what is known shows at once (`ReadChildSnapshotUseCase`); only what is
    still coming is an `AppSkeleton` under one `AppShimmer`, in the shape of
    the content (design: "LGS Ödül Avı Loading"). A first load never maps to
    `AppLoadingView`; a tab coming back refreshes quietly. ⚙

## Commands

```bash
flutter run --flavor dev                                  # or prod
dart run tool/generate_project_map.dart                   # after moving/adding files
dart run build_runner build --delete-conflicting-outputs  # after @injectable / @JsonSerializable
flutter gen-l10n                                          # after editing app_tr.arb
dart run flutter_flavorizr -p android:icons,ios:icons     # after changing assets/brand/ icons
dart run flutter_native_splash:create                     # after flutter_native_splash.yaml
```

Never run `flutter_flavorizr -f`: it rewrites `ios/`/`android/` and drops the
Firebase and signing wiring (`check_structure` would catch it). ⚙

## Flavors and platform

dev `com.lgsrewardhunt.app.dev` "LGS Ödül Avı Dev" · prod
`com.lgsrewardhunt.app` "LGS Ödül Avı" — installed side by side. Firebase project
`lgs-reward-hunt`, one app per flavor; Google/Apple sign-in through Firebase Auth.
Per-flavor iOS values (`DEVELOPMENT_TEAM`, `GOOGLE_CLIENT_ID`,
`GOOGLE_REVERSED_CLIENT_ID`, `CODE_SIGN_ENTITLEMENTS`) live in
`ios/Flutter/<flavor><Config>.xcconfig` AND flavorizr `buildSettings`. ⚙ No
backend yet: `main` installs the in-memory mock (`infrastructure/network/mock/`,
content in `assets/mock/*.json`).

## Git and release — [WORKFLOW.md](WORKFLOW.md)

Branch from `dev` → gate → one `code-reviewer` pass on the diff → PR to `dev`
(CI gate required) → squash merge. A merge to `dev` ships the dev app to
Firebase App Distribution (Android) and TestFlight; `dev` → `main` is a release
(ask first) and ships prod to Firebase, Play internal testing and TestFlight.
Never commit keystores, `key.properties` or `.p8` keys.
