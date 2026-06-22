# OTIUM AI OS — installer (Windows / PowerShell).
# Ensures Node.js (and npx) are available — needed by the plugins and the Obsidian connector.
# Safe to run multiple times.
# Your AI can run this for you, or run it yourself:  powershell -ExecutionPolicy Bypass -File setup.ps1
$ErrorActionPreference = "Stop"

if ((Get-Command node -ErrorAction SilentlyContinue) -and (Get-Command npx -ErrorAction SilentlyContinue)) {
  Write-Host "OK: Node.js $(node -v) and npx are already installed. Nothing to do."
  exit 0
}

Write-Host "Node.js / npx not found. Installing Node LTS via winget..."

if (Get-Command winget -ErrorAction SilentlyContinue) {
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
  Write-Host ""
  Write-Host "OK: Node install requested."
  Write-Host "-> Close and reopen Claude Code (or PowerShell) so it picks up Node, then continue onboarding."
} else {
  Write-Host "winget not found. Install Node.js (LTS) manually from https://nodejs.org, then reopen Claude Code."
}
