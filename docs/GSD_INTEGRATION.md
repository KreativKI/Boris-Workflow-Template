# GSD Integration Guide: Boris Workflow + Get-Shit-Done

## Overview

This guide explains how to use **Get-Shit-Done (GSD)** orchestration with **Boris Workflow** quality gates for multi-week projects.

**Quick decision:**
- **Small task (hours to days):** Use Boris Workflow alone ✓
- **Large project (weeks to months):** Use GSD + Boris integration ✓✓

---

## What is GSD?

Get-Shit-Done is a project orchestration system designed for multi-week development projects. It prevents context rot by breaking work into atomic tasks executed in fresh Claude contexts.

**GSD provides:**
- Project structure (PROJECT.md, ROADMAP.md, CONTEXT.md)
- Phase-based workflow (Initialize → Discuss → Plan → Execute → Verify)
- Atomic task breakdown with parallel execution
- Fresh 200k context window per task
- Systematic verification checkpoints

**What GSD doesn't provide:**
- Code quality review
- Architecture validation
- Build/test verification
- Code simplification

This is where Boris Workflow agents fill the gaps.

---

## What is Boris Workflow?

Boris Workflow is a quality-focused development methodology with 6 specialized agents:

| Agent | Purpose |
|-------|---------|
| `code-architect` | Design implementation blueprints |
| `code-reviewer` | Find bugs and security issues |
| `code-simplifier` | Clean up code for clarity |
| `build-validator` | Verify builds and tests pass |
| `verify-app` | Test application functionality |
| `oncall-guide` | Production incident response |

**Boris excels at:** Code quality, but doesn't orchestrate multi-week projects.
**GSD excels at:** Project orchestration, but doesn't provide quality gates.

**Together:** Project orchestration + Code quality = Complete workflow ✨

---

## Installation

### Prerequisites

- Claude Code CLI installed
- Node.js/npm (for GSD installation)
- Boris Workflow Template (this repository)

### Install GSD Globally

**Option 1: Use the setup script (Recommended)**

```bash
cd /path/to/your/project  # Must be in Boris template folder
./claude/setup-gsd.sh
```

The script will:
1. Install GSD globally via `npx get-shit-done-cc --global`
2. Show available GSD commands
3. Link to this integration guide

**Option 2: Manual installation**

```bash
npx get-shit-done-cc --global
```

GSD commands install to: `~/.claude/commands/gsd/`

### Verify Installation

```bash
# In Claude Code, type:
/gsd:
# You should see autocomplete with GSD commands
```

---

## The Integrated Workflow

### Phase-by-Phase Integration

```
┌─────────────────────────────────────────────────────────────┐
│  GSD Phase            Boris Quality Gate                     │
├─────────────────────────────────────────────────────────────┤
│  1. INITIALIZE        (No Boris integration)                 │
│     /gsd:new-project  → Creates project structure            │
│                                                               │
│  2. DISCUSS           ✓ code-architect                       │
│     /gsd:discuss-N    → Capture decisions                    │
│                       → User runs code-architect to validate │
│                                                               │
│  3. PLAN              (No Boris integration)                 │
│     /gsd:plan-N       → Creates atomic tasks                 │
│                                                               │
│  4. EXECUTE           ✓ code-reviewer + code-simplifier      │
│     /gsd:execute-N    → Runs tasks in parallel               │
│                       → User runs agents after completion    │
│                                                               │
│  5. VERIFY            ✓ verify-app + code-reviewer           │
│     /gsd:verify-N     → Manual UAT testing                   │
│                       → User runs verify-app for tests       │
│                                                               │
│  6. COMPLETE          (No Boris integration)                 │
│     /gsd:complete-M   → Archives milestone                   │
└─────────────────────────────────────────────────────────────┘
```

### Integration Type: Manual

Boris agents are **manually invoked** by the user between GSD command phases. This gives you full control over when quality gates run.

**Why manual?**
- You choose when to run quality checks
- Simpler integration (no automatic hooks)
- Clear, explicit workflow
- Easier for novices to understand

---

## Complete Example: Building an E-Commerce Site

See [examples/gsd-ecommerce-example.md](../examples/gsd-ecommerce-example.md) for a full walkthrough.

**Quick overview:**

```
# 1. Initialize project
/gsd:new-project
[Name: E-Commerce Platform]
[Description: Online store with product catalog, cart, checkout]

# 2. Discuss Phase 1: User Authentication
/gsd:discuss-phase 1
[Captures decisions: JWT tokens, bcrypt hashing, session management]

# QUALITY GATE: Validate architecture
"Use code-architect to validate the authentication architecture"
[code-architect reviews decisions, suggests improvements]

# 3. Plan Phase 1
/gsd:plan-phase 1
[Creates atomic tasks: T1.1 User model, T1.2 Auth API, T1.3 Login UI, etc.]

# 4. Execute Phase 1
/gsd:execute-phase 1
[Executes tasks in parallel, commits each atomically]

# QUALITY GATE: Review and simplify code
"Run code-reviewer and code-simplifier on phase 1"
[code-reviewer finds 3 security issues → fixed]
[code-simplifier cleans up code → 20% more readable]

# 5. Verify Phase 1
/gsd:verify-work 1
[Manual UAT: Test login, logout, password reset]

# QUALITY GATE: Run automated tests
"Use verify-app to run automated tests"
[verify-app: All 47 tests passing ✓]

# 6. Complete milestone (repeat for phases 2, 3, etc.)
/gsd:complete-milestone
```

---

## Command Reference

### GSD Commands (from plugin)

| Command | Description |
|---------|-------------|
| `/gsd:new-project` | Initialize new multi-week project |
| `/gsd:discuss-phase N` | Capture architectural decisions for phase N |
| `/gsd:plan-phase N` | Break phase N into atomic tasks |
| `/gsd:execute-phase N` | Execute tasks in parallel with fresh contexts |
| `/gsd:verify-work N` | Verify phase N with UAT checklist |
| `/gsd:complete-milestone` | Archive milestone and tag release |

### Boris Agents (built into template)

**How to invoke:**
```
User: "Use code-architect to validate the architecture"
Claude: [Runs Task(subagent_type="code-architect", prompt="...")]
```

| Agent | When to Use |
|-------|-------------|
| `code-architect` | After `/gsd:discuss-phase N` to validate architectural decisions |
| `code-reviewer` | After `/gsd:execute-phase N` to find bugs and security issues |
| `code-simplifier` | After code-reviewer passes to clean up code |
| `build-validator` | After `/gsd:execute-phase N` to verify build/tests |
| `verify-app` | During `/gsd:verify-work N` for automated testing |

---

## Best Practices

### 1. Validate Architecture Early

**Always run code-architect after DISCUSS phase:**

```
User: /gsd:discuss-phase 1
GSD:  [Captures decisions]
User: "Use code-architect to validate the architecture"
```

**Why:** Catch architectural issues before writing code.

### 2. Quality Gates After Execution

**Always run agents after EXECUTE completes:**

```
User: /gsd:execute-phase 1
GSD:  [Completes tasks]
User: "Run code-reviewer, code-simplifier, and build-validator"
```

**Why:** Find bugs, clean code, verify build in one batch.

### 3. Automate Testing in VERIFY

**Always run verify-app during VERIFY phase:**

```
User: /gsd:verify-work 1
GSD:  [Manual UAT testing]
User: "Use verify-app to run automated tests"
```

**Why:** Catch regressions before marking phase complete.

### 4. Keep Phases Focused

**Rule:** Each phase should take 1-3 days max.

**Example breakdown for e-commerce:**
- Phase 1: User authentication (2 days)
- Phase 2: Product catalog (2 days)
- Phase 3: Shopping cart (2 days)
- Phase 4: Checkout flow (3 days)
- Phase 5: Payment integration (2 days)

**Why:** Smaller phases = better context management, easier verification.

---

## When to Use What

### Use Boris Workflow Alone (No GSD)

**Perfect for:**
- Bug fixes (hours)
- Single features (1-2 days)
- Quick improvements
- Prototypes

**Example:** "Add dark mode toggle to settings page"

### Use GSD + Boris Integration

**Perfect for:**
- Multi-phase projects (weeks)
- Large features (5+ days)
- Complex systems
- Production applications

**Example:** "Build complete e-commerce platform"

---

## Troubleshooting

### GSD commands not showing in autocomplete

**Check:**
```bash
ls ~/.claude/commands/gsd/
```

**Fix:** Re-run installation:
```bash
npx get-shit-done-cc --global
```

### Boris agents not working

**Check:**
```bash
ls .claude/agents/
# Should show: code-architect.md, code-reviewer.md, etc.
```

**Fix:** You're not in a Boris template folder. Copy the template first:
```bash
cp -r boris_claude_code_template my-project
cd my-project
```

### GSD creating too many tasks

**Solution:** Make phases smaller and more focused. Aim for 5-10 tasks per phase, not 50.

### Code quality declining mid-project

**Solution:** You're skipping Boris quality gates. Always run agents after EXECUTE:
```
"Run code-reviewer and code-simplifier on all phase N changes"
```

---

## Advanced: Customizing the Workflow

### Adding Custom Quality Gates

Edit `.claude/workflows/boris-gsd-integration.md` (created during setup) to add your own checkpoints:

```markdown
## Custom Quality Gate: Security Scan

**When:** After EXECUTE, before code-reviewer
**Command:** "Run security scan with Snyk"
**Agent:** None (manual step)
```

### Adjusting GSD Settings

See GSD documentation: `/tmp/gsd-reference/README.md` (cloned during planning)

---

## FAQ

### Q: Do I need to install GSD for every project?

**A:** No! GSD installs globally (`~/.claude/commands/gsd/`). Install once, use everywhere.

### Q: Can I use GSD without Boris agents?

**A:** Yes, but you'll miss quality gates. GSD orchestrates, Boris ensures quality.

### Q: Can I use Boris without GSD?

**A:** Yes! Boris works standalone for small tasks. Only add GSD for multi-week projects.

### Q: What if my project grows from small to large?

**A:** Start with Boris alone. When you realize it's multi-week, run:
```bash
./claude/setup-gsd.sh
/gsd:new-project
```
Then migrate your existing work into GSD phases.

### Q: How do I know if I need GSD?

**Decision rule:** If your project will take >1 week of development time, use GSD.

---

## Resources

### Boris Workflow
- **Original source:** [Boris Cherny's X post](https://x.com/bcherny/status/2007179832300581177)
- **Template README:** [README.md](../README.md)
- **Template CLAUDE.md:** [CLAUDE.md](../CLAUDE.md)

### Get-Shit-Done (GSD)
- **Official repo:** [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done)
- **Version:** v1.6.4 (verified for this integration)

### Examples
- **E-commerce walkthrough:** [examples/gsd-ecommerce-example.md](../examples/gsd-ecommerce-example.md)

---

## Summary

**Boris + GSD Integration gives you:**

✅ **Project orchestration** (GSD phases)
✅ **Code quality** (Boris agents)
✅ **Context management** (fresh 200k per task)
✅ **Systematic verification** (checkpoints at every phase)
✅ **Simple adoption** (one-command setup, manual gates)

**Result:** Ship multi-week projects with confidence, not context rot.

**Get started:**
```bash
./claude/setup-gsd.sh
/gsd:new-project
```

Happy building! 🚀
