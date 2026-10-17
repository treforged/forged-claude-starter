# forged-claude-starter

A small set of reusable [Claude Code](https://claude.com/claude-code) skills: engineering patterns, testing workflows and a few operations checklists.

## Install

    git clone <this repo> && cd forged-claude-starter
    ./setup.sh          # macOS, Linux, Git Bash
    ./setup.ps1         # Windows PowerShell

The script copies each folder in `skills/` into `~/.claude/skills`. Set `CLAUDE_HOME` to use another location. It moves any skill with the same name to a timestamped backup folder first, takes no secrets, makes no network call, and prints the undo command.

Read a skill before you rely on it. Each folder holds one `SKILL.md`.

## Licence

MIT. See `LICENSE`. Third-party material is listed in `THIRD-PARTY.md`.
