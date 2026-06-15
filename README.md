# gavel 👨‍⚖️

Multi-model fusion for Antigravity, Claude Code, and Codex CLI. Ask Claude/Antigravity + Codex + Gemini in parallel, then judge their answers into one and act on it.

> *“The more tokens you throw at SOTA models, the better the answer.*
> *Cast your prompt into a solitary mind, and you receive a mere response.*
> *But weave a million tokens across a chorus of State-of-the-Art intellects, and you uncover the truth.”*

![DRACO benchmark scores](1781544730189.png)

[📸 View an Example Run in the CLI](IMG_20260615_185839.jpg)

---

## 🌟 Inspiration

Gavel is inspired by OpenRouter's [**Fusion beats Frontier**](https://openrouter.ai/blog/announcements/fusion-beats-frontier/): dispatch a prompt to a panel of models, then have a judge synthesize their answers into one response that beats any single frontier model. Gavel brings that pattern to local agentic CLIs. Codex and Gemini answer as read-only advisors, and their answers are judged and fused into one before the main model acts on it.

---

## 🚀 Installation

Because Gavel is purely prompt-and-skill-driven, you can install it into any modern agentic CLI.

### For Antigravity CLI
```bash
git clone https://github.com/ProxyAyush/antigravity-fusion-plugin.git
agy plugin install ./antigravity-fusion-plugin
```

### For Claude Code
```bash
/plugin marketplace add /path/to/antigravity-fusion-plugin
/plugin install gavel@gavel
```

### For Codex CLI
```bash
/plugin marketplace add /path/to/antigravity-fusion-plugin
/plugin install gavel@gavel
```

---

## ⚡ Quick Start & Setup

Run the setup command to check if Codex and Gemini CLIs are installed, authenticated, and recent enough:

```bash
/gavel:setup
```

It will offer to install whatever is missing. Authentication steps:
- **Codex** — `!codex login` (install: `npm install -g @openai/codex`).
- **Gemini** — run `!gemini` once to log in (OAuth), or `export GEMINI_API_KEY=…` (install: `npm install -g @google/gemini-cli`).

Gavel needs **at least one** advisor usable, but works best with both.

---

## 📖 Commands

| Command | What it does |
| --- | --- |
| `/gavel:fuse <task>` | Ask Claude/Antigravity + Codex + Gemini in parallel, synthesize one fused answer, then act on it. |
| `/gavel:ask <codex\|gemini> <prompt>` | Send a prompt to a single model and show its answer verbatim (no fusing, no edits). |
| `/gavel:setup` | Check/install/auth the Codex and Gemini CLIs. |
| `/gavel:config [show \| set <key> <value> \| unset <key>]` | View or change settings (model, timeout, panel) in the user or `--project` config file. |

---

## 🔒 How advisors stay read-only

Only the main model (Claude or Antigravity) modifies your workspace. The advisors are constrained because their CLIs differ:
- **Codex** runs in your project under its OS read-only sandbox (`-s read-only`) — a hard boundary: it reads your code but cannot change it.
- **Gemini** has no equivalent read-only sandbox, so Gavel runs it **isolated**: in a throwaway directory with `PWD`/`OLDPWD`/`INIT_CWD` scrubbed, so it cannot discover your repo path or make relative writes. It answers from the task text — include any code/context Gemini should see directly in your task.
- Prompts are passed via a temp file and reach each CLI on **stdin**, never through the shell or process arguments (preventing command injection).

---

## ⚙️ Configuration

Easiest way to change settings is the `config` command:

```bash
/gavel:config show                       # Show effective settings
/gavel:config set timeout 600            # Set 10-minute timeout for all projects
/gavel:config set codex.model gpt-5.5    # Pin a specific model
/gavel:config set gemini.model gemini-2.5-pro --project   # Pin model for this repo only
/gavel:config unset codex.model          # Restore the preferred default
```

Or edit the file directly (`~/.gavel/config.json` for user, `./.gavel.json` for project):

```json
{
  "providers": {
    "codex":  { "enabled": true, "model": "gpt-5.5-pro" },
    "gemini": { "enabled": true, "model": "gemini-3.1-pro" }
  },
  "panel": ["codex", "gemini"],
  "timeout": 1800
}
```

---

## ❓ FAQ

<details>
<summary>▶️ Who is the judge model and how can I change it?</summary>
<br>
The Judge Model is simply the model you currently have active in your CLI window when you run the `/gavel:fuse` command. To change the judge model, just switch your active model in the CLI before invoking fusion. For example, if you want Claude to judge Gemini and GPT, just select Claude as your active CLI model!
</details>

<details>
<summary>▶️ How can I easily change the models inside the fusion panel?</summary>
<br>
You can easily adjust settings using the `/gavel:config set` command or edit `~/.gavel/config.json`. If you want to configure which CLIs are queried, update the `"panel"` array in the config file.
</details>

<details>
<summary>▶️ Can this be used in other CLIs like Claude Code and Codex?</summary>
<br>
Yes! Gavel is fully compatible with Claude Code, Codex, and Antigravity. It registers standard slash commands and runs completely locally using standard plugin mechanisms.
</details>

<details>
<summary>▶️ Where does the final synthesized answer go?</summary>
<br>
To keep your chat clean, the full synthesis is saved to `synthesis.md` in your current working directory. In the chat, you will see a brief telemetry table, a 2-3 sentence summary of the final results, and a prompt asking if you'd like to read the file or implement the results directly.
</details>

<details>
<summary>▶️ Does this actually call different API models under the hood?</summary>
<br>
Yes! To bypass the limitations of CLI subagents inheriting the parent model, Gavel spins up actual background processes of the independent advisor CLIs (`codex` and `gemini`) in parallel. This forces separate agentic runs to execute under different model configurations/endpoints, which are then read and synthesized by the Judge.
</details>

---

## 🧪 Testing

Run the deterministic test suite:
```bash
bash scripts/smoke-test.sh
```

## 📄 License

MIT — see [LICENSE](./LICENSE).
