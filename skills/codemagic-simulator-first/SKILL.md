---
name: codemagic-simulator-first
description: Spend CI and build minutes carefully on iOS apps built through Codemagic. Use before starting any Codemagic, GitHub Actions or Vercel build, or when a build failed and a retry is being planned.
---

# Simulator first, then one build

Minutes are finite (the Codemagic macOS free tier is 500 a month, shared by all apps). A failed build is paid for.

## Order

1. **Local gates first:** unit tests, typecheck, press scripts, rendered frames.
2. **One simulator run** on Codemagic (no signing, no upload) proves that the native code compiles: new plugins, entitlements, Swift changes. Read its log for compile errors and runtime diagnostics.
3. **Fix every known defect** found there. Then ask the lead session for the go.
4. **One signed build and upload.** Read the upload step's own output: `UPLOAD SUCCEEDED with no errors`. The run conclusion alone is not proof.
5. **Name the build** by the number the owner sees in TestFlight.

## Rules

- Read the minute balance before a build. Tell the lead session when it is under 150.
- Group related changes into one push. Name the batch in the commit body.
- Never start a build only to test a small change.
- Exception: a release blocker or a broken production site may build at once. Say so in the commit.
- A UI test that fails only on timing (an animation racing a tap) is a test race. Fix it with a settle-wait helper. Then run it many times (for example 8) and report the real pass count.
