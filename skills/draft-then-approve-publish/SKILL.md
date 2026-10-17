---
name: draft-then-approve-publish
description: Publish listings, posts or products to an outside service (a marketplace, a print service, social) in two steps, draft then approve. Use for any action that goes public in the owner's name.
---

# Draft, then approve, then publish

Publishing is outward-facing and hard to undo. It never happens in the same step as drafting.

## Steps

1. **Draft** on the service as a draft, or in a local file. Titles, copy, tags, price, images.
2. **Read it back** from the service, not from the local file. Compare field by field.
3. **Show the owner** the exact list to publish: ids, titles, prices, fees. Send mockups as files.
4. **Approval is typed in the own session.** A relayed yes from another session does not count.
5. **Publish only the approved ids** with a script that takes the ids as arguments. A script that publishes "all drafts" is unsafe and must be refused.
6. **Verify live.** Open the public page and check title, price and image. Record the ids and the fees in the ledger.
7. **Set a follow-up date** for the first traffic read (for example 2 weeks out). Drop the surface if the traffic is near zero.

## Rules

- Name any cost (listing fees, ads) with its total before step 4.
- State the undo up front: the unpublish or deactivate command, per id.
- Never store the service's tokens in the script. Read them from the environment.
