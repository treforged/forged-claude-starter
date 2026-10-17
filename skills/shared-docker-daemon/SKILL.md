---
name: shared-docker-daemon
description: Rules for using Docker when several session sessions share one Docker daemon on this machine. Use before starting, stopping or pruning Docker, running DB red-proof containers, or whenever a game is running.
---

# Shared Docker daemon

One Docker Desktop serves every session. Stopping it kills every other session's containers. Starting it costs RAM and GPU headroom.

## Before you touch Docker

1. Run `docker ps` first. List who else is running. Names like `supabase_*_<repo>-local` belong to another session.
2. If the daemon is off and you need it: check that no game is running, start it, and tell the lead session by name.
3. Pin images by digest in proof scripts (`postgres:16-alpine@sha256:...`). A floating tag makes a red-proof impossible to reproduce.

## While you use it

- Name your containers with your repo as a prefix. Stop only your own: `docker stop <your-name>`.
- Never run `docker system prune`, `docker rm -f $(docker ps -aq)` or `docker compose down` outside your own project.
- A proof run creates and destroys its own database. It never points at a real project.

## When you finish

- Stop your containers. If yours were the only ones, stop Docker Desktop and tell the lead session.
- If you stopped another session's containers by accident, tell that session by name at once and give the restart command.
