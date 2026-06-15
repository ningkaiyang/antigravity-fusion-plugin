---
description: View or change fusion panel settings
argument-hint: "[show | set <models>]"
---

Manage your fusion panel models. Preference file: `~/.fusion_panel_prefs.txt`.

Raw arguments:
$ARGUMENTS

Decide the action from the arguments:

- **No args, or `show`**:
  Run this command to show the current panel:
  ```bash
  if [ -f "$HOME/.fusion_panel_prefs.txt" ]; then
    echo "Current Fusion Panel Models:"
    cat "$HOME/.fusion_panel_prefs.txt" | sed 's/^/  - /'
  else
    echo "No models configured. Run /fusion:setup to configure them."
  fi
  ```
- **`set <models>`** (where models are comma-separated or space-separated):
  Extract the models from the argument, and write them (one per line) to `~/.fusion_panel_prefs.txt`.
  ```bash
  # Example: echo -e "Gemini 3.5 Flash (High)\nClaude Sonnet 4.6 (Thinking)" > ~/.fusion_panel_prefs.txt
  ```
  Then print a success message and show the new configuration.
