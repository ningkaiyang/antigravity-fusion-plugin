# Antigravity Fusion Plugin

This plugin enables a Native Multi-Model Fusion Panel for the Antigravity CLI, allowing you to orchestrate multiple LLM subagents and aggregate their outputs. It acts as an orchestrator, drawing inspiration from [OpenRouter's Fusion capabilities](https://openrouter.ai/docs/guides/features/plugins/fusion), bringing multi-model orchestration directly to your terminal.

![Surpassing Frontier Performance with Fusion](https://openrouter.ai/blog/images/blog/fusion-benchmark.jpg)

## 🌟 Features
- **Virtual Model Registration**: Injects `fusion-model` straight into your Antigravity models menu.
- **Interactive TUI**: On selection, immediately hooks into a `gum`-powered checklist allowing you to pick dynamic local or cloud models.
- **Custom API Support**: Hot-swap any external models that expose a standard REST API (e.g., Claude Code via Anthropic API, Codex via OpenAI API).
- **Multi-Agent Fan-Out**: Automatically spawns background subagents for your selected models, runs them concurrently, and judges their insights (identifying consensus, contradictions, unique insights, and blind spots).
- **God-Tier Synthesis**: Delivers a definitive, high-quality synthesized answer grounded in multi-model findings.

## 📊 Why Use Fusion? (Benchmarks)
As demonstrated by OpenRouter's internal testing on the DRACO deep research benchmark, panels of models consistently outperform individual models. 

![DRACO benchmark scores for Fusion and solo configurations](https://openrouter.ai/blog/images/blog/fusion-benchmark-chart.png)

A budget panel consisting of lightweight models (e.g., Gemini 3 Flash + Kimi K2.6 + DeepSeek V4 Pro) successfully beat out top standalone models like GPT-5.5 and Opus 4.8 while being highly cost-efficient!

![Score vs cost per task for Fusion and solo configurations](https://openrouter.ai/blog/images/blog/fusion-benchmark-cost.png)

## 🚀 Installation

Install this plugin directly via the Antigravity CLI using the GitHub repository:

```bash
agy plugin install ProxyAyush/antigravity-fusion-plugin
```

*(If testing locally, you can also link it by cloning this repository into your `~/.antigravity/plugins/` directory).*

## 📖 Usage
1. Type `/models` in the Antigravity CLI.
2. Select **🧠 Fusion Engine (Multi-Model Panel)** from the dropdown.
3. Use the interactive checklist to select which models to include in your panel. You can select built-in models or add Custom APIs!
4. Type your prompt in the chat (e.g., *"Vibe code a Solarpunk game engine"*).
5. The CLI will orchestrate the search, run independent models in the background, synthesize their insights, and present you with the final result!

## 🛠 Directory Structure
```text
antigravity-fusion-plugin/
├── plugin.json               # Registers the model and the UI hook
├── skills/
│   └── fusion.md             # The core multi-agent orchestrator
└── scripts/
    └── configure_panel.sh    # The interactive TUI menu
```

## 📚 References
- Built for Antigravity 2.0 Plugin Architecture (Virtual Agents & Lifecycle Hooks).
- Inspired by OpenRouter's [Fusion API](https://openrouter.ai/docs/guides/features/plugins/fusion) and [Fusion Beats Frontier Benchmark](https://openrouter.ai/blog/announcements/fusion-beats-frontier/).
