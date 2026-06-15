---
description: Check the Fusion setup, available models, and configured panel preferences
argument-hint: ""
---

Run:

```bash
FUSION_SCRIPT=""
if [ -n "$ANTIGRAVITY_PLUGIN_ROOT" ] && [ -f "$ANTIGRAVITY_PLUGIN_ROOT/scripts/fusion.mjs" ]; then
  FUSION_SCRIPT="$ANTIGRAVITY_PLUGIN_ROOT/scripts/fusion.mjs"
elif [ -n "$CLAUDE_PLUGIN_ROOT" ] && [ -f "$CLAUDE_PLUGIN_ROOT/scripts/fusion.mjs" ]; then
  FUSION_SCRIPT="$CLAUDE_PLUGIN_ROOT/scripts/fusion.mjs"
elif [ -f "./scripts/fusion.mjs" ]; then
  FUSION_SCRIPT="./scripts/fusion.mjs"
else
  for dir in "$HOME/.antigravity/plugins/antigravity-fusion-plugin" "$HOME/.antigravity/plugins/fusion"; do
    if [ -f "$dir/scripts/fusion.mjs" ]; then
      FUSION_SCRIPT="$dir/scripts/fusion.mjs"
      break
    fi
  done
fi
if [ -z "$FUSION_SCRIPT" ]; then
  echo "Error: fusion.mjs not found!"
  exit 1
fi
node "$FUSION_SCRIPT" setup --json
```

Read the JSON report. It lists:
- `cli`: Detected host CLI (e.g. `agy`).
- `prefsExists`: Whether `~/.fusion_panel_prefs.txt` exists.
- `prefs`: The models currently configured in the panel.
- `availableModels`: List of all models available in the CLI.

Then present the setup report:
- If preferences do not exist (`prefsExists: false`), ask the user:
  > *"Welcome to Fusion! Since this is your first time, what models do you want to include in your panel? Please select from the available models in your CLI (e.g. Gemini 3.5 Flash (High), Claude Sonnet 4.6 (Thinking), GPT-OSS 120B (Medium))."*
  Save their choices (one per line) to `~/.fusion_panel_prefs.txt`.
- If preferences exist, print a clean table showing the configured panel models and list the other available models they can configure.
- Inform them they can change models anytime by editing `~/.fusion_panel_prefs.txt`.
