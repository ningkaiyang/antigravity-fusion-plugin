# Universal Fusion Plugin

Multi-model fusion for Antigravity, Claude Code, and Codex CLI. Fan out your prompt to a panel of models, synthesize the best answer, get per-model telemetry, and receive a compiled `synthesis.md` file. Inspired by [OpenRouter's Fusion](https://openrouter.ai/docs/guides/features/plugins/fusion).

![Surpassing Frontier Performance with Fusion](https://openrouter.ai/blog/images/blog/fusion-benchmark.jpg)

## 🌟 Features
- **Skill-based invocation**: Just type `/fusion` followed by your prompt. Works universally across CLIs.
- **Cross-CLI Support**: Seamlessly works inside Antigravity, Claude Code, and Codex CLI.
- **Interactive First-Run Setup**: The agent will automatically ask you to define your custom model panel on your first run.
- **Bring Your Own Judge**: The "Judge Model" is simply the model you currently have active in your CLI. Want Claude to judge Gemini and GPT? Just set Claude as your active model before running `/fusion`!
- **Multi-agent fan-out**: Spawns parallel subagents across the models you select.
- **Markdown Synthesis**: Saves the final God-tier synthesis directly to `synthesis.md` in your current directory, keeping your chat clean.
- **Per-model telemetry**: Every run ends with a ✅/❌ health table showing exactly what happened in the chat.

## 📊 Why Fusion Works

OpenRouter's DRACO benchmark proved that panels of models consistently outperform individual models — even budget panels beat frontier models.

![DRACO benchmark scores](https://openrouter.ai/blog/images/blog/fusion-benchmark-chart.png)

## 🚀 Installation

Because Fusion is purely prompt-and-skill-driven, you can install it into any modern agentic CLI.

### For Antigravity CLI
```bash
git clone https://github.com/ProxyAyush/antigravity-fusion-plugin.git
agy plugin install ./antigravity-fusion-plugin
```

### For Claude Code
Claude Code automatically scans `SKILL.md` files in your `.claude/skills` directory.
```bash
mkdir -p ~/.claude/skills/fusion
curl -o ~/.claude/skills/fusion/SKILL.md https://raw.githubusercontent.com/ProxyAyush/antigravity-fusion-plugin/master/skills/fusion.md
```

### For Codex CLI
Codex CLI automatically scans `SKILL.md` files in your `.codex/skills` directory.
```bash
mkdir -p ~/.codex/skills/fusion
curl -o ~/.codex/skills/fusion/SKILL.md https://raw.githubusercontent.com/ProxyAyush/antigravity-fusion-plugin/master/skills/fusion.md
```

## 📖 Usage

### First Run
Type `/fusion hello` in your chat. The agent will detect that you haven't set up your panel yet and will ask you:
> *"Welcome to Fusion! What models do you want to include in your panel? Please give me a list of models available in your CLI."*

Reply with your models (e.g., "Claude 3.5 Sonnet, GPT-4o, Gemini 1.5 Pro"). The agent will save these preferences globally.

### Running Fusion
Simply type `/fusion` followed by your prompt:
```
/fusion What's the best architecture for a Solarpunk game engine?
```

The agent will:
1. Print a spinning banner showing your panel spinning up.
2. Spawn parallel subagents for each model.
3. Judge & synthesize their responses.
4. Output a **per-model telemetry table** in the chat.
5. Save the final deep analysis to `synthesis.md` in your current folder.

## 📚 References
- [OpenRouter Fusion API Docs](https://openrouter.ai/docs/guides/features/plugins/fusion)
- [Fusion Beats Frontier Benchmark](https://openrouter.ai/blog/announcements/fusion-beats-frontier/)
