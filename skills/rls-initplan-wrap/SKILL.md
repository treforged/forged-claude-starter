---
name: rls-initplan-wrap
description: Fix the Supabase advisor warning auth_rls_initplan by wrapping auth.uid() as (select auth.uid()) in RLS policies, safely. Use when get_advisors lists auth_rls_initplan, when RLS policies call auth.uid(), auth.jwt() or auth.role() per row, or before rewriting any RLS policy on live data.
---

# RLS initplan wrap

Postgres runs `auth.uid()` once per row. `(select auth.uid())` runs it once per query. The meaning stays the same. The cost drops.

## Procedure (one table at a time, never a blind bulk rewrite)

1. **Measure.** `get_advisors` type `performance`. Record the count of `auth_rls_initplan` rows. This is the number to beat.
2. **Snapshot.** Save `select schemaname, tablename, policyname, cmd, roles, qual, with_check from pg_policies` to a file in the repo. This file is the undo.
3. **Generate the rewrite from the snapshot**, not by hand. Replace each bare `auth.uid()`, `auth.jwt()` and `auth.role()` with `(select auth.xxx())`. Skip any call that already sits inside `(select ...)`.
4. **Apply in ONE transaction** per table (drop policy, create policy, repeat, commit). One failed statement then leaves the old policies in place.
5. **Read back.** Query `pg_policies` again. Assert: the wrapped count rose, the unwrapped count is 0, and `cmd`, `roles` and `permissive` are unchanged for every policy.
6. **Two-user cross-read test.** Inside a transaction, insert two throwaway users, `set local role authenticated`, set `request.jwt.claim.sub`, and assert that user A reads only A rows and cannot read B rows. `ROLLBACK`. Leave no row.
7. **Red control.** Run the same test against a deliberately broken policy (`using (true)`). It must fail. A test that passes on the broken policy proves nothing.
8. **Re-run the advisor.** The `auth_rls_initplan` count must fall to 0 for that table.

## Rules

- Never change the logic while wrapping. A policy that also needs a fix gets its own migration.
- Name the undo in the migration text: the snapshot file plus the command that replays it.
- On real user data, run steps 1 to 3 first and show the diff before step 4.
- Say what the gate does not cover: policies on views, security-definer functions, storage policies.
