# Installs the skills in .\skills into ~\.claude\skills (or $env:CLAUDE_HOME\skills).
# Takes no secrets and makes no network call. Same-named skills are moved to a backup first.
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE '.claude' }
$dest = Join-Path $root 'skills'
$backup = Join-Path $root ('skills-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$installed = 0; $backed = 0
foreach ($src in Get-ChildItem -Directory (Join-Path $here 'skills')) {
  if (-not (Test-Path (Join-Path $src.FullName 'SKILL.md'))) { continue }
  $target = Join-Path $dest $src.Name
  if (Test-Path $target) {
    New-Item -ItemType Directory -Force -Path $backup | Out-Null
    Move-Item $target (Join-Path $backup $src.Name); $backed++
  }
  Copy-Item -Recurse $src.FullName $target; $installed++
}
if ($installed -eq 0) { Write-Error 'No skills found next to this script'; exit 1 }
Write-Host "Installed $installed skill(s) into $dest ($backed backed up)."
if ($backed -gt 0) { Write-Host "UNDO: delete each new copy in $dest, then move each folder in $backup back." }
else { Write-Host "UNDO: remove the installed folders from $dest (names are in .\skills)." }
