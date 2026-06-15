---
description: Ask multiple models in parallel, synthesize one fused answer, then act on it
argument-hint: "<task or question>"
---

You are running a multi-model fuse for this request. You are the **judge and the actor**. The panel models are **read-only advisors** — only you write to the workspace or run side-effecting commands.

The task / question:
$ARGUMENTS

If the task is empty, ask the user what they want fused, then stop.

Follow these steps in order:

**1. Your independent draft (blind — before the panel).** Form your **own complete answer first**, with no knowledge of what the panel will say. Read whatever repo context you need, then use the **Write tool** to save your full answer to a fresh temp file, e.g. `/tmp/fusion-draft-<timestamp>.md`. This file is **your committed panelist submission**: it must stand on its own and include your recommendation, key claims, assumptions, risks, and concrete next actions. Do **not** edit the workspace yet, and do **not** revise this draft after seeing the panel.

**2. Consult the panel.** Get the task to the advisors:
- Use the **Write tool** to write the verbatim task text to a fresh temp file with a unique name, e.g. `/tmp/fusion-prompt-<timestamp>.txt`. Delete it afterward.
- Then run this — only the fixed file path is in the shell, never the task text:

```bash
FUSION_SCRIPT=""
if [ -n "$CLAUDE_PLUGIN_ROOT" ] && [ -f "$CLAUDE_PLUGIN_ROOT/scripts/fusion.mjs" ]; then
  FUSION_SCRIPT="$CLAUDE_PLUGIN_ROOT/scripts/fusion.mjs"
elif [ -f "./scripts/fusion.mjs" ]; then
  FUSION_SCRIPT="./scripts/fusion.mjs"
else
  for dir in "$HOME/.antigravity/plugins/antigravity-fusion-plugin" "$HOME/.antigravity/plugins/fusion" "$HOME/.antigravity/plugins/openrouter-fusion-local" "/root/antigravity-fusion-plugin"; do
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

**3. Judge & synthesize.** Now read **all submissions** — your own draft file from step 1, and the panel outputs — and apply the **fusion-synthesis** skill to fuse them. Your draft is a **fixed, co-equal input**, not a baseline to defend: extract each panelist's claims separately, identify consensus, contradictions, partial coverage, unique insights, and blind spots, then derive a **single fused answer**. Save this synthesis directly to `synthesis.md` in the current directory.

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
