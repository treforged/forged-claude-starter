---
name: apple-client-secret-rotation
description: Rotate the Sign in with Apple client secret (a JWT that expires every 6 months) used by Supabase Auth. Use when Apple sign-in fails with invalid_client, when the renewal reminder fires, or when a Services ID or Apple key changes.
---

# Apple client-secret rotation

The Apple "secret" is an ES256 JWT built from a `.p8` key. Apple caps its life at 6 months. When it lapses, sign-in fails with `invalid_client` in the auth log, on web and on iOS.

## Procedure

1. **Confirm the cause.** Read the auth log. `invalid_client` on the Apple callback means the secret is expired or mismatched.
2. **Inputs** (kept outside the repo): the `.p8` path, the key id, the team id, the Services ID. If the `.p8` is lost, create a new key in Apple Developer. That step needs the owner's hands.
3. **Mint** with the local script your local mint script. It signs the JWT (180 days) and writes it to the CLIPBOARD only. It never prints the JWT or the key.
4. **Test before pasting.** Run it with `--test`. It posts the JWT to Apple with a fake code. `invalid_grant` means Apple accepts the secret. `invalid_client` means Apple rejects it.
5. **Paste** into Supabase Auth, Apple provider, Secret Key. Use the keyboard paste and click Save. Never read the field back.
6. **Prove it.** The auth log error changes from `invalid_client` to `invalid_grant` on a fake code. Then a real sign-in works on web first, then on the device.
7. **Set the next reminder** 30 days before expiry. Put the expiry date and the exact mint command in its text.

## Rules

- The secret and the `.p8` never enter the transcript, a commit, a note or a ledger line. Record only the key id, the expiry date and the result.
- Use screenshots only on the Supabase and Apple pages. Use no page-reading tool on a page that can show a key.
- The paste is a secret write. It needs the owner's typed approval in the session tab.
