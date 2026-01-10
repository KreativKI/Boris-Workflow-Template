# Boris Workflow Guide for Non-Developers

**What is the Boris Workflow?**
A development methodology by Boris Cherny (creator of Claude Code) that ensures code quality through systematic verification at each step. Think of it like quality control checkpoints in film production.

**Source:** [Boris Cherny's Claude Config](https://github.com/0xquinto/bcherny-claude)

---

## The Core Loop

```
1. EXPLORE → 2. PLAN → 3. CODE → 4. VERIFY → 5. SIMPLIFY → 6. COMMIT
```

**Film Analogy:**
1. **Explore** = Location scouting
2. **Plan** = Storyboarding
3. **Code** = Principal photography
4. **Verify** = Reviewing dailies
5. **Simplify** = Editing the rough cut
6. **Commit** = Final cut locked

---

## All 6 Boris Agents ✅

All agents are now installed from official sources:

### From Anthropic Plugins (`claude-code-plugins`)

| Agent | Source | Purpose |
|-------|--------|---------|
| `code-architect` | `feature-dev` plugin | Designs feature architectures |
| `code-reviewer` | `feature-dev` plugin | Reviews code for bugs and issues |
| `code-simplifier` | `pr-review-toolkit` plugin | Cleans up code for readability |

### From Boris Cherny's Config (`bcherny-claude`)

| Agent | Purpose |
|-------|---------|
| `build-validator` | Validates build, typecheck, lint, tests |
| `verify-app` | Verifies app functionality after changes |
| `oncall-guide` | Incident response and troubleshooting |

---

## Agent Details

### 1. Build Validator (`build-validator.md`) 🟢
**Source:** [bcherny-claude](https://github.com/0xquinto/bcherny-claude)
**When:** Before committing, after any code changes
**What it does:** Runs clean build, typecheck, lint, and tests
**Film Analogy:** The lab checking the film negatives for defects

### 2. Code Architect (`code-architect.md`) 🔵
**Source:** `feature-dev` plugin (Anthropic)
**When:** Before writing complex features
**What it does:** Designs the implementation approach
**Film Analogy:** The production designer planning the set

### 3. Code Reviewer (`code-reviewer.md`) 🔴
**Source:** `feature-dev` plugin (Anthropic)
**When:** After writing code, before committing
**What it does:** Reviews for bugs, security issues, code quality
**Film Analogy:** The script supervisor checking for continuity errors

**Only reports issues with confidence ≥ 80%** to minimize noise.

### 4. Code Simplifier (`code-simplifier.md`) 🟡
**Source:** `pr-review-toolkit` plugin (Anthropic)
**When:** After code review passes
**What it does:** Cleans up code for readability without changing functionality
**Film Analogy:** The editor trimming unnecessary footage

### 5. Verify App (`verify-app.md`) 🟣
**Source:** [bcherny-claude](https://github.com/0xquinto/bcherny-claude)
**When:** After any changes to verify they work
**What it does:** Static analysis, automated tests, manual verification, edge cases
**Film Analogy:** Color timing and final QC in post-production

### 6. On-Call Guide (`oncall-guide.md`) 🟠
**Source:** [bcherny-claude](https://github.com/0xquinto/bcherny-claude)
**When:** Production issues or incident response
**What it does:** Guides through incident severity, investigation, resolution
**Film Analogy:** The on-set medic and safety coordinator

---

## When to Use Each Agent

| Situation | Agent(s) to Use |
|-----------|-----------------|
| Starting a new feature | `code-architect` |
| After writing code | `build-validator` → `code-reviewer` |
| Before committing | `code-simplifier` |
| After any changes | `verify-app` |
| Production issues | `oncall-guide` |
| Ready to commit | All checks pass! |

---

## The Complete Workflow Checklist

For each feature or fix:

```
□ 1. EXPLORE
   - Read relevant files first
   - Understand existing code
   - Don't write code yet

□ 2. PLAN (for complex tasks)
   - Use code-architect agent
   - Or: Enter Plan Mode (Shift+Tab twice)
   - Get user approval on approach

□ 3. CODE
   - Write the implementation
   - PostToolUse hook auto-formats code

□ 4. BUILD VALIDATE
   - Use build-validator agent
   - Or manually: bun run typecheck && bun run lint

□ 5. TEST
   - Run: bun run test
   - All tests should pass

□ 6. VERIFY
   - Use verify-app agent
   - Or: bun run build && bun run dev

□ 7. SIMPLIFY
   - Use code-simplifier agent
   - Apply improvements

□ 8. REVIEW
   - Use code-reviewer agent
   - Fix any high-confidence issues

□ 9. COMMIT
   - Stage changes
   - Write descriptive commit message
   - Push to GitHub
```

---

## Quick Commands for You (The User)

| What You Want | What to Say |
|---------------|-------------|
| Full workflow | "Follow the Boris workflow for this task" |
| Validate build | "Use build-validator" |
| Review code | "Use code-reviewer to review my code" |
| Simplify code | "Use code-simplifier on recent changes" |
| Verify app | "Use verify-app to test changes" |
| Design feature | "Use code-architect to design this feature" |
| Production issue | "Use oncall-guide to help diagnose" |

---

## PostToolUse Hook (Auto-Format)

The project has a hook in `.claude/settings.json` that automatically formats code after every edit:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bun run format || true"
          }
        ]
      }
    ]
  }
}
```

---

## Official Sources

All agents come from verified sources:

| Source | URL | Agents |
|--------|-----|--------|
| Anthropic Plugins | `~/.claude/plugins/marketplaces/claude-code-plugins/` | code-architect, code-reviewer, code-simplifier |
| Boris Cherny's Config | https://github.com/0xquinto/bcherny-claude | build-validator, verify-app, oncall-guide |
| Anthropic Skills | https://github.com/anthropics/skills | Official skill templates |

---

## Template Status

- ✅ 6 official agents installed (all from verified sources)
- ✅ PostToolUse hook configured (auto-format)
- ✅ 4 commands configured
- ✅ Comprehensive CLAUDE.md with learning journal
- ✅ Adapted for bun (not just npm)

**This template is ready to use! Copy it to new projects.**

---

## How to Use This Template

1. Copy the entire `boris_claude_code_template` folder to your new project
2. Rename it or copy contents into your project's root
3. Customize CLAUDE.md for your specific project
4. Run `bun install` (or `npm install`) to set up the project
5. Start using the Boris workflow!

---

## Template vs Official Comparison

Your template is **more comprehensive** than the official bcherny-claude:

| Feature | Official | Your Template |
|---------|----------|---------------|
| CLAUDE.md | Basic template | Comprehensive with examples |
| Agents | 5 basic | 6 detailed (including code-reviewer) |
| Commands | 5 simple | 4 comprehensive (commit-push-pr, code-review, etc.) |
| Thinking modes | None | 4 levels documented |
| Visual verification | None | Playwright workflow |
| Learning journal | Concept only | Actual examples |

**The Boris workflow is fully operational with all official agents!**
