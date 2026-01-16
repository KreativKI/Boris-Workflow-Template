# Boris Workflow Template — CLAUDE.md

**Based on:** Boris Cherny's Claude Code Workflow
**Purpose:** Agent's "Living Memory" - prevents context amnesia and compounds knowledge
**Backup:** `CLAUDE.md.backup-full` contains extended guidelines if needed

---

## The Workflow

```
EXPLORE → PLAN → CODE → VERIFY → SIMPLIFY → COMMIT
```

1. **Explore:** Read relevant files first ("don't write code yet")
2. **Plan:** Use Plan Mode (Shift+Tab twice) for complex problems
3. **Code:** Implement the solution
4. **Verify:** Run tests, use Playwright for visual verification
5. **Simplify:** Run code-simplifier agent
6. **Commit:** Use `/commit-commands:commit-push-pr`

---

## Thinking Modes

| Phrase | Use When |
|--------|----------|
| "think" | Outline logic briefly |
| "think hard" | Step-by-step reasoning |
| "think harder" | Exhaustive analysis with alternatives |
| "ultrathink" | Full architectural review, edge-cases, security |

---

## Available Agents

Project-local agents in `.claude/agents/`:

| Agent | When to Use |
|-------|-------------|
| `code-architect` | Before complex features - design implementation blueprint |
| `code-reviewer` | After writing code - find bugs (confidence ≥80%) |
| `code-simplifier` | After review passes - clean up code |
| `build-validator` | Before committing - validate build/tests |
| `verify-app` | After changes - verify functionality works |
| `oncall-guide` | Production incidents - incident response |

---

## Available Plugins

Install globally for full Boris workflow:

```bash
claude plugin add ralph-loop@claude-plugins-official
claude plugin add commit-commands@claude-plugins-official
claude plugin add feature-dev@claude-plugins-official
claude plugin add pr-review-toolkit@claude-plugins-official
claude plugin add agent-sdk-dev@claude-code-plugins
```

| Plugin | Command | Use When |
|--------|---------|----------|
| `ralph-loop` | `/ralph-loop:ralph-loop "task"` | Long autonomous tasks with clear completion criteria |
| `commit-commands` | `/commit-commands:commit-push-pr` | Git workflow (commit, push, PR) |
| `feature-dev` | `/feature-dev:feature-dev` | Guided feature development |
| `pr-review-toolkit` | `/pr-review-toolkit:review-pr` | Comprehensive PR review |
| `agent-sdk-dev` | `/agent-sdk-dev:new-sdk-app` | Creating Claude Agent SDK apps |

---

## What Boris Would Do

| Situation | Approach |
|-----------|----------|
| Starting new feature | Plan Mode → `/feature-dev` → code-reviewer → code-simplifier → commit |
| Long autonomous task | `/ralph-loop` with clear completion criteria |
| Creating Agent SDK app | `/agent-sdk-dev:new-sdk-app` |
| Code review | Run code-reviewer agent |
| Before PR | build-validator → verify-app agents |
| After writing code | code-simplifier agent |
| Complex architecture | code-architect agent |
| Production incident | oncall-guide agent |

---

## Git Workflow

- **Branch First:** Never commit directly to main
- **Commit Often:** When a step is complete and verified
- **Conventional Commits:** Use `feat:`, `fix:`, `docs:`, `refactor:`, etc.

---

## Visual Verification

**CRITICAL:** After creating HTML/Web content, use Playwright to verify rendering.

```
Write Code → Open Browser → Analyze Screenshot → Fix if needed
```

This delivers 2-3x quality improvement over blind coding.

---

## Skills & Agents Policy

**STRICT: Never edit downloaded skills/agents without explicit user permission.**

Before modifying ANY skill/agent file:
1. STOP and notify user why the edit is needed
2. Wait for explicit approval
3. If declined, suggest alternatives (create new instead)

Before creating custom skills:
1. Check `~/.claude/plugins/cache/`
2. Check project `.claude/skills/` and `.claude/agents/`
3. Only create new if nothing suitable exists

---

## Meta-Rule

**Every mistake → add a rule here.**

This is how the agent learns. Document: what went wrong, the new rule, date added.

### Learned Rules

| Date | Mistake | Rule |
|------|---------|------|
| 2026-01-09 | Created custom subagent when official exists | Always check plugin marketplace first |
| 2026-01-09 | Hook without error handling blocked edits | Always use `|| true` in hook commands |
| 2026-01-09 | Assumed HTML renders correctly | Always use Playwright visual verification |
| 2026-01-12 | Edited downloaded agent without permission | Never edit downloaded skills/agents without approval |

---

## Project-Specific Section

Add your project's specifics below:

```
# Build Commands
# bun run build / npm run build / pytest / etc.

# Test Commands
# bun run test / pytest / etc.

# Key Files
# List critical files for this project

# Project Conventions
# Any project-specific patterns
```

---

## References

- [Boris Cherny's X post](https://x.com/bcherny/status/2007179832300581177)
- [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
