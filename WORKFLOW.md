# Workflow

From a change to a store, the same way every time. CLAUDE.md carries the rules;
this is the sequence.

## 1. Branch from `dev`

```bash
git checkout dev && git pull
git checkout -b <feat|fix|refactor|chore>/<short-name>
```

## 2. Build it

Follow CLAUDE.md. Commit in atomic, conventional commits (`feat(rewards): …`,
`fix(auth): …`). The pre-commit hook runs `flutter analyze` and
`dart run tool/check_structure.dart` (enable once per clone:
`git config core.hooksPath .githooks`).

## 3. Gate, then review

```bash
flutter analyze && dart run tool/check_structure.dart && flutter test
```

Then one review of the diff by the `code-reviewer` agent
(`.claude/agents/code-reviewer.md`), scoped to `git diff dev...HEAD`.
`REQUEST CHANGES` loops back to step 2; a merge never goes over it.

## 4. Pull request to `dev`

```bash
git push -u origin <branch>
gh pr create --base dev --title "<conventional title>" --body "<what and why>"
```

CI (`.github/workflows/ci.yml`) runs the gate on the PR. `dev` and `main` are
protected: a merge needs the PR and a green gate.

```bash
gh pr merge <number> --squash --delete-branch
```

**A merge to `dev` ships a dev build:** the Android dev APK to Firebase App
Distribution (group `testers`), and the iOS dev app to TestFlight *and* Firebase
App Distribution — one archive exported twice. The iOS build on Firebase is
ad-hoc, so it installs only on devices registered in the Apple Developer
account: add a tester's UDID there (Firebase's iOS tester flow collects it),
then the next build reaches them. TestFlight needs no UDID.

## 5. Version numbers

The version name is semantic and lives once, in `pubspec.yaml`:

```bash
dart run tool/bump_version.dart patch   # a fix
dart run tool/bump_version.dart minor   # a feature
dart run tool/bump_version.dart major   # something a user has to relearn
```

Bump it on a branch, like any change, before the release PR. The build number
after `+` is never edited by hand: CI uses run number × 10 + attempt + 1000, so
every upload to a store is higher than the last. A merge to `main` tags
`v<version>-build.<n>`.

## 6. Release: `dev` → `main`

Only when dev is what should reach testers of the real app. **Ask first.**

```bash
dart run tool/bump_version.dart patch   # on a branch, merged to dev first
gh pr create --base main --head dev --title "release: <version>" --body "<changes>"
gh pr merge <number> --merge
```

**A merge to `main` ships prod:** the Android prod APK to Firebase App
Distribution, the prod AAB to Google Play internal testing, and the iOS prod app
to TestFlight and Firebase, then tags `v<version>-build.<n>`. Bump `version:` in
`pubspec.yaml` for a new version name; build numbers are automatic
(run number × 10 + attempt + 1000).

## Obfuscated builds

Every build CI ships is obfuscated: `--obfuscate --split-debug-info=build/symbols/<platform>`
strips Dart class and method names from the package. The symbol files that read
a crash back are kept as a run artifact (`symbols-<platform>-<flavor>-<build>`,
90 days) and never shipped. To read a tester's stack trace:

```bash
gh run download <run-id> -n symbols-ios-prod-1234
flutter symbolize -i trace.txt -d app.ios-arm64.symbols
```

Locally the same flags apply — see the release build commands in CLAUDE.md.
Android code shrinking (R8) is on by default for a release build.

## Where each build goes

| | Firebase App Distribution | TestFlight | Google Play |
|---|---|---|---|
| `dev` push (dev flavor) | Android APK + iOS ad-hoc | iOS dev app | — |
| `main` push (prod flavor) | Android APK + iOS ad-hoc | iOS prod app | internal testing (AAB) |

Every build is obfuscated. Firebase takes both platforms in both flavors;
Play takes prod only, because there is one listing.

## Secrets (GitHub → Settings → Secrets and variables → Actions)

| Secret | What | Used by |
|---|---|---|
| `FIREBASE_CONFIG_ARCHIVE` | base64 tar.gz of the six Firebase config files (`google-services.json` ×2, `GoogleService-Info.plist` ×2, `firebase_options_*.dart` ×2), kept out of the public repo | every job, gate included |
| `ANDROID_KEYSTORE_BASE64` | `base64` of the upload keystore | Firebase, Play |
| `ANDROID_KEYSTORE_PASSWORD` / `ANDROID_KEY_ALIAS` / `ANDROID_KEY_PASSWORD` | its passwords and alias | Firebase, Play |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | service account with *Firebase App Distribution Admin* | Firebase |
| `PLAY_SERVICE_ACCOUNT_JSON` | service account invited in Play Console with release rights | Play |
| `APP_STORE_CONNECT_KEY_ID` / `APP_STORE_CONNECT_ISSUER_ID` / `APP_STORE_CONNECT_KEY_P8` | App Store Connect API key (**Admin** role — CI signs with cloud-managed certificates) | TestFlight |

A distribution job whose secrets are missing is skipped with a notice. Variable
`PLAY_RELEASE_STATUS=draft` is needed until the Play listing is complete; after
that the default, `completed`, rolls internal releases out.

The upload keystore lives outside the repo at `~/.lgs-reward-hunt-signing/`
(`upload.jks`, `key.properties`). **Back it up** — Play App Signing can reset a
lost upload key, but only through support.

### Refreshing the Firebase config secret

After `flutterfire configure`, a key rotation or a new SHA-1, re-upload the six
files:

```bash
tar czf - android/app/src/{dev,prod}/google-services.json \
  ios/config/{dev,prod}/GoogleService-Info.plist \
  lib/infrastructure/config/firebase/firebase_options_{dev,prod}.dart \
  | base64 | gh secret set FIREBASE_CONFIG_ARCHIVE
```

## Firebase from the agent

`.mcp.json` registers the Firebase CLI's MCP server (`firebase mcp --dir .`),
so a session can read the project, its apps, App Distribution and Auth without
shelling out. It uses whatever `firebase login` on the machine is signed in as.

