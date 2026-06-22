#!/usr/bin/env bash
# OTIUM AI OS — installer (macOS / Linux).
# Ensures Node.js (and npx) are available — needed by the plugins and the Obsidian connector.
# Safe to run multiple times. No admin password, no Homebrew.
# Your AI can run this for you, or run it yourself:  bash setup.sh
set -e

say() { printf '%s\n' "$*"; }

if command -v node >/dev/null 2>&1 && command -v npx >/dev/null 2>&1; then
  say "✓ Node.js $(node -v) and npx are already installed. Nothing to do."
  exit 0
fi

say "Node.js / npx not found. Installing Node LTS via nvm (user-space — no admin, no Homebrew)…"

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
fi

# load nvm into this shell
# shellcheck disable=SC1091
\. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts

if command -v node >/dev/null 2>&1; then
  say ""
  say "✓ Installed Node $(node -v) with npx."
  say "→ Close and reopen Claude Code (or your terminal) so it picks up Node, then continue onboarding."
else
  say ""
  say "Could not confirm Node on PATH. Open a NEW terminal and run:  node -v"
  say "If that still fails, install Node manually from https://nodejs.org (the green LTS button)."
fi
