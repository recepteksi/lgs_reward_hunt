# LGS Ödül Avı

A **parent-controlled, gamified task-and-reward app** for students preparing for
the Turkish LGS exam. The loop: task → complete → earn points → choose a reward →
a parent approves.

Flutter · package `lgs_reward_hunt` · application id `com.lgsrewardhunt.app`

## Features

- **Map** — one stop a day; a path that advances as tasks are done, and an exam countdown.
- **Tasks** — a daily study plan by subject, with a duration and points per task.
- **Rewards** — spend points on rewards the family agreed on; each request waits for a parent's approval.
- **Progress** — streak, weekly chart, monthly strip and badges.
- **Profile** — avatar, theme and colour, exam date, linked parent.
- **Parent mode** — behind a PIN: approve reward requests, edit the task plan and the reward pool.
- **Sign-in** — email, Google and Apple (Firebase Auth).

## Requirements

| Tool | Version |
|---|---|
| Flutter | 3.47 (stable) |
| Dart SDK | ^3.13.2 |
| Xcode | current, with CocoaPods — for iOS |
| Android Studio / SDK | for Android |

## Setup

```bash
git clone <repo-url> && cd lgs_reward_hunt
flutter pub get
git config core.hooksPath .githooks   # enables the pre-commit checks (once per clone)
```

### Firebase config files

The repo is public, so the Firebase client files are **not in it**
(`.gitignore`), and the app does not build without them. Get the six files
from the project owner and put them in place:

```
android/app/src/dev/google-services.json
android/app/src/prod/google-services.json
ios/config/dev/GoogleService-Info.plist
ios/config/prod/GoogleService-Info.plist
lib/infrastructure/config/firebase/firebase_options_dev.dart
lib/infrastructure/config/firebase/firebase_options_prod.dart
```

With access to the Firebase project, `flutterfire configure` generates them
too. CI restores them from the `FIREBASE_CONFIG_ARCHIVE` secret (see
[WORKFLOW.md](WORKFLOW.md)).

## Running

Two flavors, installable side by side:

| Flavor | Application id | Name |
|---|---|---|
| `dev` | `com.lgsrewardhunt.app.dev` | LGS Ödül Avı Dev |
| `prod` | `com.lgsrewardhunt.app` | LGS Ödül Avı |

```bash
flutter run --flavor dev
flutter run --flavor prod
```

### Test data (mock backend)

There is no server yet: the app runs on an in-memory mock backend
(`lib/infrastructure/network/mock/`, content in `assets/mock/*.json`). Its data
is kept on the device until the app is deleted.

Demo account:

| | Value |
|---|---|
| Parent email | `ayse@ornek.com` |
| Password | `lgs12345` |
| Parent PIN | `1234` |
| Link code | `LGS274` |

In the dev flavor a see-through test button on every screen shows these
values; tapping a row copies it.

## Development

A change is not done while any of these is red (CI runs the same three):

```bash
flutter analyze
dart run tool/check_structure.dart
flutter test
```

Frequent commands:

```bash
dart run build_runner build --delete-conflicting-outputs  # after @injectable / @JsonSerializable
flutter gen-l10n                                          # after editing app_tr.arb
dart run tool/generate_project_map.dart                   # after adding or moving files
```

### Architecture

Clean Architecture + DDD, layer → feature folders:

```
lib/
  core/            shared bases, constants, Failure, validators
  domain/          entities, value objects, read models, rules, interfaces
  application/     use cases, one Cubit per page, DI
  infrastructure/  repositories, services, DTOs, the mock backend
  presentation/    pages, router, shared UI widgets
```

Dependencies point `core ← domain ← application ← infrastructure`;
`presentation` never reaches infrastructure. Errors are values
(`Either<Failure, T>`). Everything is English except the app's copy, which is
Turkish and lives only in `app_tr.arb` (through `AppL10n`).

More:

- [CLAUDE.md](CLAUDE.md) — the rules
- [architecture.md](architecture.md) — why each rule exists
- [PROJECT-MAP.md](PROJECT-MAP.md) — the file map (generated)
- [BUILD-PLAN.md](BUILD-PLAN.md) — what is open
- [docs/regressions.md](docs/regressions.md) — past bug classes and their guards

## Release

The flow is in [WORKFLOW.md](WORKFLOW.md): branch from `dev` → gate → PR to
`dev` → squash merge. A merge to `dev` ships the dev app to Firebase App
Distribution and TestFlight; `dev` → `main` is a release and ships prod to
Firebase, Google Play internal testing and TestFlight. Every build is
obfuscated. Release notes live in [CHANGELOG.md](CHANGELOG.md).

```bash
flutter build appbundle --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android
```
