#!/usr/bin/env bash
# Installs the skills in ./skills into ~/.claude/skills (or $CLAUDE_HOME/skills).
# Takes no secrets and makes no network call. Existing skills with the same name are
# moved to a timestamped backup folder first. The undo command is printed at the end.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
home="${CLAUDE_HOME:-$HOME/.claude}"
dest="$home/skills"
backup="$home/skills-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$dest"
installed=0; backed=0
for src in "$here"/skills/*/; do
  [ -f "$src/SKILL.md" ] || continue
  name="$(basename "$src")"
  if [ -e "$dest/$name" ]; then
    mkdir -p "$backup"; mv "$dest/$name" "$backup/$name"; backed=$((backed+1))
  fi
  cp -R "$src" "$dest/$name"; installed=$((installed+1))
done
if [ "$installed" -eq 0 ]; then echo "FAIL: no skills found next to this script"; exit 1; fi
echo "Installed $installed skill(s) into $dest ($backed backed up)."
if [ "$backed" -gt 0 ]; then
  echo "UNDO: for d in \"$backup\"/*/; do rm -rf \"$dest/\$(basename \$d)\"; mv \"\$d\" \"$dest/\"; done"
else
  echo "UNDO: remove the installed folders from $dest (names are in ./skills)."
fi
