# Build plan

**Status:** Slices 0–8 are built — onboarding, the four child tabs, the parent
gate and page, Firebase platform sign-in, icons and launch screen. How each was
built, and why, is in [docs/build-log.md](docs/build-log.md).

**Resuming:** read [CLAUDE.md](CLAUDE.md) and [PROJECT-MAP.md](PROJECT-MAP.md),
then take the first open item below. Tick it when the gate is green.

## Design source

Claude Design project `9adc491c-8580-4bf3-a6bf-81f2c80b24ba`, read with
`DesignSync`: `LGS Ödül Avı.dc.html` (twelve screens; its `DCLogic` state and
methods are the flow spec — save it to a file and grep, never read whole),
`LGS Ödül Avı UI Kit.dc.html`, `LGS Ödül Avı Brand.dc.html` (icon, launch),
`avatars.json`. The older project `7f80d0df-…` is not authoritative.

## Open

- [ ] A real backend to replace the mock (Firestore + Cloud Functions are the
      natural fit in the existing Firebase project). Testers see device-only
      data that resets with the app until then.
- [ ] Design's sizes artboard (icon scale, paddings, control heights) has not
      landed; `AppSizes` holds values read off the prototype.
- [ ] First `main` release: it ships prod to Firebase, Play internal testing and
      TestFlight at once — bump `version:` in `pubspec.yaml` first.

## Shipping (working)

`dev` → Android dev APK to Firebase App Distribution (group `testers`) and iOS
dev to TestFlight, both obfuscated, symbols kept as a run artifact. `main` adds
the Play internal track. Secrets and the manual steps are in
[WORKFLOW.md](WORKFLOW.md).

## Known, accepted

- Two contrast pairs sit under 4.5:1 (a label on the red accent, 4.13; the muted
  meta line, 3.13–4.46) — the design's own values, pinned by
  `app_theme_test.dart`.
- Entities compare by id, so a draft plan whose line was edited equals the old
  plan. No state compares plans today; if one ever does, drafts become value
  objects.
