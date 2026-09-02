# CLAUDE.md

Guidance for Claude Code working in this repository. The reasoning behind these
rules is in [architecture.md](architecture.md).

## What this is

**LGS Ödül Avı** — a parent-controlled, gamified task-and-reward app for
students preparing for the Turkish LGS exam.

The loop is: **task → complete → earn points → choose a reward → parent
approves**. A parent creates daily tasks (name, category, time, duration,
points); the child earns points by completing them and spends them in a reward
shop the two agreed on; every redemption waits for the parent. The home screen
counts down to the exam date, which changes every year.

Flutter · `lgs_reward_hunt` · `com.lgsrewardhunt.app`

## Architecture in one screen

```
core ← domain ← application ← infrastructure
                    ↑              ↑
                    └─ presentation ┘
```

`presentation` may **not** import `infrastructure`. Only `application/di/` knows
about both.

- **`core/`** — `Result<T>`, `Failure`, named constants. Imports nothing.
- **`domain/`** — entities and repository **interfaces**. No Flutter import.
- **`application/`** — use cases, Cubits + sealed states, DI. No Flutter widgets.
- **`infrastructure/`** — repository implementations, config, IO.
- **`presentation/`** — screens, widgets, router, theme, l10n.

## Mandatory standards

1. **One exported declaration per file.** The exception is a `sealed` type,
   whose variants Dart requires to share its library (`Failure`,
   `ExamCountdownState`). A private helper widget in the same file as the screen
   that uses it is fine — it publishes nothing.

2. **Errors are values.** `domain/` and `application/` never throw; they return
   `Result<T>`. A `Failure` carries a **`messageKey`, never a sentence** —
   `failureCopy` is the one place a key becomes words.

3. **Ports are `*Interface`, in a `*_interface.dart` file.** The suffix goes at
   the END, spelled out. Never a leading `I`.

4. **Entities own their rules.** A derivation that reads an entity's fields is a
   method on the entity, not a helper in a Cubit or a widget. Private
   constructor + static `create()` returning `Result`, so an instance that
   exists is one whose invariants held.

5. **Cubits orchestrate; they do not compute.** They call use cases and emit
   state. A Cubit that owns a timer or subscription cancels it in `close()`.

6. **State is `sealed`, one variant per thing the screen can show.** Never one
   class with `isLoading`, `failure` and `data` all nullable — that permits
   states nobody designed.

7. **No magic values.** A design measurement goes in `presentation/theme/`
   (`AppSpacing`, `AppRadii`, `AppTypography`); a colour comes from
   `Theme.of(context).colorScheme`, never named in a widget; a duration goes in
   `core/constants/`; a failure key goes in `FailureMessageKey`. A number in a
   widget is a number nobody can search for.

8. **All copy through `AppL10n`.** A string literal in a widget cannot be
   translated and is invisible until someone switches language. **Turkish is the
   template**, English the translation. Plurals use ICU, never an `if` — the
   zero case is often a different sentence, not a different number.

9. **Only the composition root and a screen's `BlocProvider` touch `getIt`.**
   Everything else takes dependencies through its constructor.

10. **Package imports everywhere** (`package:lgs_reward_hunt/...`). A `../../..`
    says nothing about which layer it crossed, and crossing one is exactly what
    needs to be visible. Enforced by `always_use_package_imports`.

11. **A bug fix ships the test that would have caught it.** It must fail against
    the unfixed code. Name it after the SYMPTOM, not the mechanism. Then ask
    whether a lint or a type could have caught it — a rule the analyzer enforces
    beats a rule written down.

12. **One `main.dart`.** The flavor arrives from the build. Anything that
    differs between environments is read through `AppConfig`, never by asking
    `F.appFlavor` at the point of use.

## Commands

```bash
flutter run --flavor dev            # or prod
flutter analyze                     # must be clean — it is the first gate
flutter test
dart run build_runner build --delete-conflicting-outputs   # after @injectable changes
flutter gen-l10n                    # after editing an .arb
dart run flutter_flavorizr -f       # after changing the flavorizr: block
```

The quality gate is **`flutter analyze` clean + `flutter test` green**. Work is
not done with either red.

## Flavors

| | dev | prod |
|---|---|---|
| Application id | `com.lgsrewardhunt.app.dev` | `com.lgsrewardhunt.app` |
| Display name | LGS Ödül Avı Dev | LGS Ödül Avı |

Both install side by side on one device, deliberately. `flutter_flavorizr`
rewrites `android/` and `ios/` from the `flavorizr:` block in `pubspec.yaml` —
review that diff when you regenerate.

## Git flow

Branch from `dev`, conventional commits (`feat(tasks):`, `fix(rewards):`), PR to
`dev`. `main` is release-only. Do not commit or push unless asked.

## Not yet built

Only the skeleton exists: layers, DI, router, theme, localization, flavors, and
**one** example screen (the countdown). Tasks, rewards, the parent approval
flow, streaks, levels and achievements are not implemented — the countdown is
there to show the shape the rest should take, not because it is finished.

There is no backend yet. `AppConfig.apiBaseUrl` names hosts that do not exist.
