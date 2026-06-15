#!/bin/bash
# Ensure gum is installed for the TUI rendering
if ! command -v gum &> /dev/null; then
    echo "Installing gum for UI rendering..."
    brew install gum || sudo apt install gum -y
fi

clear
echo "⚙️  Configuring Local Fusion Engine"
echo "-----------------------------------"

# Render the interactive TUI checklist
SELECTED_MODELS=$(gum choose --no-limit --cursor=">" \
  --selected="Gemini 3.5 Flash (High),Gemini 3.1 Pro (High),Claude Opus 4.6 (Thinking)" \
  --header="Select the models you want in your panel (Space to select, Enter to confirm):" \
  "Gemini 3.5 Flash (High)" \
  "Gemini 3.5 Flash (Low)" \
  "Gemini 3.1 Pro (High)" \
  "Gemini 3.1 Pro (Low)" \
  "Claude Sonnet 4.6 (Thinking)" \
  "Claude Opus 4.6 (Thinking)" \
  "GPT-OSS 120B (Medium)" \
  "+ Add Custom API Model...")

mkdir -p ~/.antigravity/state/
echo "$SELECTED_MODELS" > ~/.antigravity/state/fusion_panel_prefs.txt

if echo "$SELECTED_MODELS" | grep -q "+ Add Custom API Model..."; then
    echo ""
    gum style --foreground 212 "🛠️  Configuring Custom API Model"
    
    CUSTOM_MODEL_NAME=$(gum input --placeholder "Enter Model Name (e.g., custom-codex, claude-code)...")
    CUSTOM_API_URL=$(gum input --placeholder "Enter API Base URL (e.g., https://api.openai.com/v1)...")
    CUSTOM_API_KEY=$(gum input --password --placeholder "Enter API Key...")

    cat <<EOF > ~/.antigravity/state/fusion_custom_model.json
{
  "model_name": "$CUSTOM_MODEL_NAME",
  "base_url": "$CUSTOM_API_URL",
  "api_key": "$CUSTOM_API_KEY"
}
EOF
    echo ""
    gum style --foreground 212 "✅ Custom API Model '$CUSTOM_MODEL_NAME' saved!"
else
    rm -f ~/.antigravity/state/fusion_custom_model.json
fi

# Clean the custom model line from prefs
sed -i '/+ Add Custom API Model.../d' ~/.antigravity/state/fusion_panel_prefs.txt

echo ""
gum style --foreground 212 "✅ Fusion Panel successfully updated!"
gum style --foreground 240 "Active panel:"
cat ~/.antigravity/state/fusion_panel_prefs.txt
if [ -f ~/.antigravity/state/fusion_custom_model.json ]; then
    echo "$CUSTOM_MODEL_NAME (Custom API)"
fi
sleep 2
clear
