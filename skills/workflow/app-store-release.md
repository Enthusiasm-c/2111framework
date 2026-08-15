---
name: app-store-release
description: Pre-submission workflow for native iOS apps (Xcode 26, SwiftUI) — run the app-store-review skill audit, archive + validate the exact build, separate upload blockers from cleanup, then TestFlight → App Review. Use when preparing a TestFlight/App Store build, answering a rejection, or when Denis asks "can we ship this to the App Store".
---

# App Store Release — fewer build & review errors

~40% of first submissions get rejected; most reasons are mechanical (missing `PrivacyInfo.xcprivacy`, vague permission strings, placeholder content, wrong screenshots). This workflow front-loads those checks so the first upload is the one that ships.

## Installed tooling

| Piece | Source | Where | Job |
|-------|--------|-------|-----|
| **`app-store-review`** skill | [dpearson2699/swift-ios-skills](https://github.com/dpearson2699/swift-ios-skills) (~1k★, 86 iOS 26 skills, part of `ios-engineering-skills`) | `~/.claude/skills/app-store-review` (global, via `npx skills`) | Audits submission readiness: current review guidelines, `PrivacyInfo.xcprivacy` + required-reason APIs, privacy labels, ATT, StoreKit, metadata, entitlements. Separates **blockers** from cleanup; re-checks the rebuilt archive. |
| Xcode 26.6 + `xcodegen` | local | `xcode-select -p` | Build/archive. Project is generated from `App/project.yml`. |

Optional, not installed (add when the release pipeline needs automation, not before):

| Piece | Source | Job |
|-------|--------|-----|
| `asc` CLI + skills | [rorkai/app-store-connect-cli-skills](https://github.com/rorkai/app-store-connect-cli-skills) (~1k★) | Build → export → upload → TestFlight → submit from the terminal (`asc-xcode-build`, `asc-release-flow`, `asc-submission-health`, `asc-testflight-orchestration`) — needs an App Store Connect API key |
| Alternative guideline auditor | [safaiyeh/app-store-review-skill](https://github.com/safaiyeh/app-store-review-skill) (Swift + RN/Expo, all 5 guideline sections) | Second opinion on compliance if a rejection cites a guideline the primary skill missed |
| Rest of `swift-ios-skills` | `npx skills add dpearson2699/swift-ios-skills` (interactive) | Install **per project** (not global): `swiftui-patterns`, `swiftui-animation`, `swift-testing`, `ios-simulator`, `debugging-instruments` are the useful ones for Tutorino |

## Workflow (do not skip steps)

### 0. Freeze the candidate
```bash
git status --short          # clean tree, or commit first
cd App && xcodegen generate # project.yml is the source of truth
```

### 1. Audit — report only, no code changes yet
Invoke the skill explicitly so it does the full pass, not just the summary:

```
Use the app-store-review skill. Audit App/ (target AsanaCoach, bundle com.denisdomashenko.asanacoach)
for App Store submission readiness. Fetch the current guidelines first. Output two lists:
BLOCKERS (would fail upload or review) and CLEANUP (fix later). Cite file:line for each.
```

What it must cover (it will — verify the report has each section):
- `PrivacyInfo.xcprivacy` present in **every** bundle that uses required-reason APIs (UserDefaults, file timestamps, boot time, disk space, keyboards) — including SwiftPM/SDK targets
- Every `NS*UsageDescription` string is specific, in the **product language**, and matches what the feature does
- Privacy nutrition labels ↔ manifest ↔ actual network behaviour tell the same story
- No placeholder/debug content in the release build; no debug-only resources shipped
- StoreKit / IAP rules if there is any paid path; ATT only if there is real cross-app tracking
- Metadata: name, subtitle, screenshots (current device-size spec), description match the binary
- Guideline 2.1 completeness: reviewer can reach every feature (demo account / review notes if a login or hardware is needed)

### 2. Fix blockers first, one class at a time
Hand each blocker to the `dev` agent as its own task. Do **not** mix "add privacy manifest" with feature work.

### 3. Archive + validate the exact submission
```bash
xcodebuild -project App/AsanaCoach.xcodeproj -scheme AsanaCoach \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath build/AsanaCoach.xcarchive archive | tail -40
xcodebuild -exportArchive -archivePath build/AsanaCoach.xcarchive \
  -exportOptionsPlist App/ExportOptions.plist -exportPath build/export | tail -20
```
Then in Xcode → Organizer → **Validate App** (catches ITMS-9xxxx: missing manifest, icon sizes, SDK floor, encryption declaration) **before** Distribute. Fix → re-archive → validate again. Never upload an archive that was not validated.

### 4. TestFlight first
Internal TestFlight build → install on the real iPhone → run the full user flow once (camera, mic, speech permission prompts appear with the right text). Only then submit for review with review notes.

### 5. Rejection handling
Paste the full rejection text to the skill:
```
Use the app-store-review skill. Apple rejected build N with this message: <paste>.
Map it to the guideline, tell me the minimal fix, and what to write in the Resolution Center reply.
```
Do not appeal first — fix + resubmit is faster unless the reviewer is factually wrong.

## Known first-audit findings for Tutorino / asana-coach (as of 2026-08-15)

Seen while wiring this skill — the audit will flag them, listed so nobody is surprised:
- No `PrivacyInfo.xcprivacy` anywhere in `App/`. App + AsanaCore code has **0** `UserDefaults` / file-timestamp / boot-time calls (grep, 2026-08-15), so the app target may legitimately not need one — but the MediaPipe binary inside `SwiftTasksVision` is a third-party SDK and must carry its own manifest; the audit has to confirm this, not assume it
- Usage strings are mixed Russian/English (`NSCameraUsageDescription`, `NSMotionUsageDescription` in RU) while the product language decision is English → make them consistent English
- `project.yml` ships `fixtures/csv/mediapipe/IMG_1092.csv` (4.7 MB, replay fixture) into the Release bundle — comment already says "remove before TestFlight"
- No `ExportOptions.plist` yet — generate once via Xcode Organizer or `asc-xcode-build`
- Version `0.1 (1)` — bump `MARKETING_VERSION` / `CURRENT_PROJECT_VERSION` per upload; App Store Connect rejects a reused build number

## Related
- `skills/design/design-stack.md` — `apple-design` skill for motion/gesture principles in the SwiftUI app
- `agents/qa.md` — pre-release checklist runs after the audit, before TestFlight
