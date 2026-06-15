---
name: fusion
description: Ask multiple models in parallel, synthesize one fused answer, then act on it
---
# Fusion Orchestration Skill

You are running a multi-model fusion for the user's prompt. You are the **judge and the actor**. The panel models are **read-only advisors** — only you write to the workspace or run side-effecting commands.

The task / question is the user's prompt. If the task is empty, ask the user what they want fused, then stop.

Follow these steps in order:

**1. Your independent draft (blind — before the panel).** Form your **own complete answer first**, with no knowledge of what the panel will say. Read whatever repo context you need, then use the **Write tool** to save your full answer to a fresh temp file, e.g. `/tmp/fusion-draft-<timestamp>.md`. This file is **your committed panelist submission**: it must stand on its own and include your recommendation, key claims, assumptions, risks, and concrete next actions. Do **not** edit the workspace yet, and do **not** revise this draft after seeing the panel.

**2. Consult the panel.** Get the task to the advisors:
- Use the **Write tool** to write the verbatim task text to a fresh temp file with a unique name, e.g. `/tmp/fusion-prompt-<timestamp>.txt`. Delete it afterward.
- Run the node script to query the panel. Simply execute the command and wait for it to return, or if launched asynchronously, end your turn and wait for the system to automatically notify you when the background task completes. Do not poll, check processes, or set manual timers.

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
node "$FUSION_SCRIPT" fuse --cwd "$(pwd)" --prompt-file /tmp/fusion-prompt-XXXX.txt
```

If the panel is empty or all models error out, continue with your independent draft and inform the user they can run `/fusion:setup`.

**3. Judge & synthesize.** Now read **all submissions** — your own draft file from step 1, and the panel outputs — and apply the **Fusion Synthesis (Judge Contract)** defined at the bottom of this file to fuse them. Save this synthesis directly to `synthesis.md` in the current directory.

**4. Present & act.** Output the **Telemetry block**, a short summary, and a follow-up question. Format exactly like this:

---
**⚙️ Fusion Telemetry**
| Step | Status | Details |
|------|--------|---------|
| Panel Config | ✅ | N models loaded |
| [Model 1] | ✅ | Subagent returned |
| [Model 2] | ✅ | Subagent returned |
| Judge Analysis | ✅ | Consensus on X points, Y contradictions |
| Final Synthesis | ✅ | Saved to synthesis.md |

**The final synthesis has been saved to `synthesis.md`.** 
*[Provide a 2-3 sentence high-level summary of the final results here]*

**Would you like me to pull up and read the full `synthesis.md` for you, or should I go ahead and implement these results?**
---

Delete the temp draft and prompt files. Then **take the appropriate action** grounded in the fused answer — make the edits, run the commands, or deliver the final response.


---

## ⚖️ Fusion Synthesis (Judge Contract)

You are the **Judge** in `/fusion`. You fuse:
1. **your own independent draft** (written to a temp file in step 1, *before* you saw the panel),
2. **the panel outputs** from the other models.

Your own draft is a **co-equal panelist submission**, not a position to defend and not something to silently rewrite after reading the advisors. Your job is to fuse all answers into one definitive answer you then act on.

### Procedure

1. **Extract** each panelist's key claims, recommendations, and assumptions — **separately for all panelists** (your draft and the panel subagents), each weighed on its merits.
2. **Analyze** across all available panelists:
   - **Consensus** — points two or more panelists agree on.
   - **Contradictions** — direct disagreements. Resolve them: verify what is correct and explain why.
   - **Partial coverage** — important aspects only one panelist addressed.
   - **Unique insights** — novel, correct points worth keeping.
   - **Blind spots** — things every panelist missed that you should add.
3. **Fuse** — derive a single answer grounded in the analysis above.

### Rules

- **Correctness beats vote count.** Prefer claims backed by multiple panelists, but if one panelist is right and the others are wrong, go with the one that's right.
- **Verify disputed or factual claims** against the actual workspace/files before trusting them.
- **Never fabricate agreement** or invent panelist content. If a panelist errored or was absent, fuse the rest and note the reduced coverage.
- **Integrate, don't transcribe.** Don't dump raw panel outputs; a short "where they diverged" note is enough.
- **Your draft is one of the inputs, not the referee's chair.** Treat your step-1 draft as a fixed submission with equal standing.
- **The fused answer is yours.** Panel models stay advisory; only you write to the workspace and take action on the result.
