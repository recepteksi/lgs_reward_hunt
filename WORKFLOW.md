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
Distribution (group `testers`) and the iOS dev app to TestFlight, in parallel.

## 5. Release: `dev` → `main`

Only when dev is what should reach testers of the real app. **Ask first.**

```bash
gh pr create --base main --head dev --title "release: <version>" --body "<changes>"
gh pr merge <number> --merge
```

**A merge to `main` ships prod:** the Android prod APK to Firebase App
Distribution, the prod AAB to Google Play internal testing, and the iOS prod app
to TestFlight, then tags `v<version>-build.<n>`. Bump `version:` in
`pubspec.yaml` for a new version name; build numbers are automatic
(run number + 100).

## Secrets (GitHub → Settings → Secrets and variables → Actions)

| Secret | What | Used by |
|---|---|---|
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
