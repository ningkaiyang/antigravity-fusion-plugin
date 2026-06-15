---
description: Check whether the Codex and Gemini CLIs are installed and authenticated for gavel
argument-hint: ""
allowed-tools: Bash(node:*), Bash(npm:*), AskUserQuestion
---

Run:

```bash
GAVEL_SCRIPT=""
if [ -n "$CLAUDE_PLUGIN_ROOT" ] && [ -f "$CLAUDE_PLUGIN_ROOT/scripts/gavel.mjs" ]; then
  GAVEL_SCRIPT="$CLAUDE_PLUGIN_ROOT/scripts/gavel.mjs"
elif [ -f "./scripts/gavel.mjs" ]; then
  GAVEL_SCRIPT="./scripts/gavel.mjs"
else
  for dir in "$HOME/.antigravity/plugins/antigravity-fusion-plugin" "$HOME/.antigravity/plugins/gavel" "$HOME/.antigravity/plugins/openrouter-fusion-local" "/root/antigravity-fusion-plugin"; do
    if [ -f "$dir/scripts/gavel.mjs" ]; then
      GAVEL_SCRIPT="$dir/scripts/gavel.mjs"
      break
    fi
  done
fi
if [ -z "$GAVEL_SCRIPT" ]; then
  echo "Error: gavel.mjs not found!"
  exit 1
fi
node "$GAVEL_SCRIPT" setup --json
```

Read the JSON report. It lists each provider under `providers.<name>` with `enabled`, `installed`,
`authed`, `usable`, `version`, `tooOld`, and `isolation`, plus top-level `ready`, `degraded`,
`missingProviders`, and `panel`. Then:

- For each provider that is **enabled but not installed** (`installed: false`) while `npm.available`
  is true, use `AskUserQuestion` **once** to ask which missing CLI(s) to install now (multi-select if
  both). Put installing first and suffix the label with `(Recommended)`. Install commands:
  - Codex: `npm install -g @openai/codex`
  - Gemini: `npm install -g @google/gemini-cli`
- Run the chosen install command(s), then rerun the setup report.
- If npm is unavailable, don't offer to install — just report and point to the install docs.

Then present the final report, preserving guidance:
- If a provider is installed but not authenticated, give its auth step: Codex → run `!codex login`;
  Gemini → run `!gemini` once (OAuth) or `export GEMINI_API_KEY=…`.
- If any provider has `tooOld: true`, warn that the installed CLI is older than the tested version and
  some required flags may be unsupported (suggest upgrading).
- A provider `disabled` in settings is intentionally skipped — do not nag about it.

Note: gavel needs **at least one** usable advisor (`ready: true`); it works best with both. Codex
explores the repo read-only; Gemini runs isolated. Model/timeout defaults and per-provider settings
live in `~/.gavel/config.json` or a project `./.gavel.json`.
