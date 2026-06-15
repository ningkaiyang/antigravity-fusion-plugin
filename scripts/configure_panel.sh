#!/bin/bash
# Ensure gum is installed for the TUI rendering
if ! command -v gum &> /dev/null; then
    echo "Installing gum for UI rendering..."
    # Antigravity's environment allows standard package pulls
    brew install gum || sudo apt install gum -y
fi

clear
echo "⚙️  Configuring Local Fusion Engine"
echo "-----------------------------------"

# Render the interactive TUI checklist
SELECTED_MODELS=$(gum choose --no-limit --cursor=">" \
  --header="Select the models you want in your panel (Space to select, Enter to confirm):" \
  "gemini-3.5-flash" \
  "gemini-3-pro" \
  "claude-sonnet-4.5" \
  "gpt-oss" \
  "deepseek-coder")

# Save the selection to a state file the Agent can read
mkdir -p ~/.antigravity/state/
echo "$SELECTED_MODELS" > ~/.antigravity/state/fusion_panel_prefs.txt

echo ""
gum style --foreground 212 "✅ Fusion Panel successfully updated!"
gum style --foreground 240 "Active subagents:"
echo "$SELECTED_MODELS"
sleep 2
clear
