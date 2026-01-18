# Boris + GSD Integration Workflow Specification

**Purpose:** Technical specifications for integrating Boris Workflow agents with Get-Shit-Done (GSD) project orchestration.

**Integration Type:** Manual (user invokes Boris agents between GSD command phases)

**Version:** 1.0.0 (compatible with GSD v1.6.4)

---

## Integration Map

### GSD Phase 1: INITIALIZE

**GSD Command:** `/gsd:new-project`

**What it does:**
- Creates PROJECT.md with project overview
- Creates REQUIREMENTS.md with acceptance criteria
- Creates ROADMAP.md with milestone breakdown
- Sets up initial project structure

**Boris Integration:** None

**Rationale:** Initialization is pure research/planning, no code exists yet.

---

### GSD Phase 2: DISCUSS

**GSD Command:** `/gsd:discuss-phase N`

**What it does:**
- Captures architectural decisions for phase N
- Updates CONTEXT.md with design choices
- Documents technical approach
- Identifies dependencies and constraints

**Boris Integration:** ✓ `code-architect` agent

**When to run:**
```
User: /gsd:discuss-phase 1
GSD:  [Captures decisions, updates CONTEXT.md]
User: "Use code-architect to validate the architecture for phase 1"
Claude: [Runs Task(subagent_type="code-architect", prompt="Review architectural decisions for phase 1 in CONTEXT.md")]
```

**What code-architect validates:**
- Design patterns chosen
- Technology stack decisions
- API/interface contracts
- Data models and schemas
- Security considerations
- Scalability approach

**Checkpoint:** Do not proceed to PLAN until code-architect approves architecture.

---

### GSD Phase 3: PLAN

**GSD Command:** `/gsd:plan-phase N`

**What it does:**
- Breaks phase into atomic tasks (T{N}.{M} format)
- Creates {phase}-{N}-PLAN.md with task breakdown
- Defines task dependencies
- Estimates task complexity

**Boris Integration:** None

**Rationale:** code-architect already validated architecture in DISCUSS phase. Planning is task breakdown, not code validation.

---

### GSD Phase 4: EXECUTE

**GSD Command:** `/gsd:execute-phase N`

**What it does:**
- Spawns parallel gsd-executor subagents for each task
- Each task gets fresh 200k context window
- Commits each task atomically with XML metadata
- Creates comprehensive implementation

**Boris Integration:** ✓ Multiple agents after execution completes

**When to run:**
```
User: /gsd:execute-phase 1
GSD:  [Executes all tasks T1.1 through T1.N in parallel]
GSD:  [Each task commits atomically]
GSD:  ✓ Phase 1 execution complete

User: "Run code-reviewer on all phase 1 changes"
Claude: [Runs Task(subagent_type="code-reviewer", prompt="Review all code changes from phase 1")]

[code-reviewer finds issues]
User: "Fix the 3 security issues found"
Claude: [Fixes issues]

User: "Now run code-simplifier on phase 1"
Claude: [Runs Task(subagent_type="code-simplifier", prompt="Simplify all phase 1 code")]

User: "Run build-validator before moving to verify"
Claude: [Runs Task(subagent_type="build-validator", prompt="Validate build for phase 1")]
```

**Agent sequence:**
1. **code-reviewer** — Find bugs, security issues, logic errors
2. Fix issues found by code-reviewer
3. **code-simplifier** — Clean up code for clarity
4. **build-validator** — Verify build, typecheck, lint, tests

**Checkpoint:** Do not proceed to VERIFY until all agents pass.

---

### GSD Phase 5: VERIFY

**GSD Command:** `/gsd:verify-work N`

**What it does:**
- Creates UAT checklist for manual testing
- Guides user through verification scenarios
- Documents test results
- Validates acceptance criteria met

**Boris Integration:** ✓ `verify-app` + `code-reviewer`

**When to run:**
```
User: /gsd:verify-work 1
GSD:  [Creates UAT checklist]
GSD:  Please verify:
      - [ ] User can register account
      - [ ] User can login with credentials
      - [ ] User can reset password
      ...

[User performs manual testing]

User: "Use verify-app to run automated tests for phase 1"
Claude: [Runs Task(subagent_type="verify-app", prompt="Run all automated tests for phase 1 functionality")]

User: "Run code-reviewer one final time on phase 1"
Claude: [Runs Task(subagent_type="code-reviewer", prompt="Final review of phase 1 before marking complete")]
```

**Agent sequence:**
1. Manual UAT testing (user performs)
2. **verify-app** — Run automated tests, static analysis, edge cases
3. **code-reviewer** — Final quality check

**Checkpoint:** Do not complete milestone until UAT and agents pass.

---

### GSD Phase 6: COMPLETE MILESTONE

**GSD Command:** `/gsd:complete-milestone`

**What it does:**
- Archives milestone documentation
- Creates git tag for release
- Updates ROADMAP.md with progress
- Prepares for next milestone

**Boris Integration:** None

**Rationale:** Milestone completion is git operations and documentation, no code changes.

---

## Prompt Templates

### Template 1: Validate Architecture (DISCUSS phase)

**User prompt:**
```
Use code-architect to validate the architecture for phase {N}
```

**Claude invocation:**
```javascript
Task(
  subagent_type="code-architect",
  prompt="Review the architectural decisions captured in CONTEXT.md for phase {N}. Validate design patterns, technology choices, API contracts, data models, security considerations, and scalability approach. Provide specific recommendations for improvements."
)
```

---

### Template 2: Review Code (EXECUTE phase)

**User prompt:**
```
Run code-reviewer on all phase {N} changes
```

**Claude invocation:**
```javascript
Task(
  subagent_type="code-reviewer",
  prompt="Review all code changes from phase {N}. Focus on bugs, security vulnerabilities, logic errors, and code quality issues. Only report issues with confidence ≥80%."
)
```

---

### Template 3: Simplify Code (EXECUTE phase)

**User prompt:**
```
Run code-simplifier on phase {N}
```

**Claude invocation:**
```javascript
Task(
  subagent_type="code-simplifier",
  prompt="Simplify all code from phase {N} for clarity, consistency, and maintainability while preserving functionality. Focus on readability improvements."
)
```

---

### Template 4: Validate Build (EXECUTE phase)

**User prompt:**
```
Run build-validator before moving to verify
```

**Claude invocation:**
```javascript
Task(
  subagent_type="build-validator",
  prompt="Validate that the project builds correctly after phase {N}. Run clean build, typecheck, lint, and tests. Report build status with recommendations."
)
```

---

### Template 5: Verify Application (VERIFY phase)

**User prompt:**
```
Use verify-app to run automated tests for phase {N}
```

**Claude invocation:**
```javascript
Task(
  subagent_type="verify-app",
  prompt="Verify phase {N} functionality through static analysis, automated tests, manual verification checks, and edge case testing. Confirm all phase {N} features work correctly."
)
```

---

## Human Checkpoints

### Checkpoint 1: Architecture Approved (after DISCUSS)

**Question to ask user:**
```
code-architect has reviewed the phase {N} architecture. Key findings:
- [Finding 1]
- [Finding 2]
- [Recommendation 1]

Should we proceed to PLAN phase, or do you want to adjust the architecture?
```

**Required:** User explicitly approves architecture before running `/gsd:plan-phase N`

---

### Checkpoint 2: Code Quality Verified (after EXECUTE)

**Question to ask user:**
```
Quality gates for phase {N} complete:
- code-reviewer: {X} issues found → {Y} fixed
- code-simplifier: {Z}% code readability improvement
- build-validator: {PASS/FAIL}

Should we proceed to VERIFY phase?
```

**Required:** User confirms quality gates passed before running `/gsd:verify-work N`

---

### Checkpoint 3: Verification Complete (after VERIFY)

**Question to ask user:**
```
Phase {N} verification complete:
- Manual UAT: {PASS/FAIL}
- verify-app: {X} tests passing
- code-reviewer: {Y} final issues

Ready to complete milestone?
```

**Required:** User confirms verification passed before running `/gsd:complete-milestone`

---

## Integration Workflow Diagram

```
START PROJECT
     ↓
/gsd:new-project
     ↓
┌────────────────────────────────┐
│  PHASE N                        │
│                                 │
│  /gsd:discuss-phase N           │
│       ↓                         │
│  ✓ code-architect               │ ← Boris Quality Gate
│       ↓                         │
│  [CHECKPOINT: Approve arch]     │
│       ↓                         │
│  /gsd:plan-phase N              │
│       ↓                         │
│  /gsd:execute-phase N           │
│       ↓                         │
│  ✓ code-reviewer                │ ← Boris Quality Gate
│  ✓ code-simplifier              │ ← Boris Quality Gate
│  ✓ build-validator              │ ← Boris Quality Gate
│       ↓                         │
│  [CHECKPOINT: Quality OK]       │
│       ↓                         │
│  /gsd:verify-work N             │
│       ↓                         │
│  ✓ verify-app                   │ ← Boris Quality Gate
│  ✓ code-reviewer (final)        │ ← Boris Quality Gate
│       ↓                         │
│  [CHECKPOINT: Verify OK]        │
│       ↓                         │
│  Phase N Complete ✓             │
└────────────────────────────────┘
     ↓
More phases? → Repeat for N+1
     ↓
/gsd:complete-milestone
     ↓
PROJECT COMPLETE
```

---

## Agent Naming: No Collision

**Finding:** GSD agents and Boris agents use completely different names with no overlap.

**GSD Agents (11 total, all prefixed `gsd-`):**
- gsd-executor
- gsd-planner
- gsd-verifier
- gsd-debugger
- gsd-phase-researcher
- gsd-project-researcher
- gsd-research-synthesizer
- gsd-codebase-mapper
- gsd-plan-checker
- gsd-roadmapper
- gsd-integration-checker

**Boris Agents (6 total, no prefix):**
- code-architect
- code-reviewer
- code-simplifier
- build-validator
- verify-app
- oncall-guide

**Conclusion:** No naming collision. Integration is complementary.

---

## Troubleshooting

### Issue: "code-architect not found"

**Cause:** Not in Boris template directory.

**Fix:**
```bash
ls .claude/agents/code-architect.md
# If missing, you're not in the template
cd /path/to/boris/template
```

---

### Issue: "GSD commands not working"

**Cause:** GSD not installed globally.

**Fix:**
```bash
npx get-shit-done-cc --global
# Verify:
ls ~/.claude/commands/gsd/
```

---

### Issue: "Quality gates slowing down development"

**Cause:** Running agents too frequently.

**Fix:** Only run agents at phase boundaries:
- code-architect: Once per phase (after DISCUSS)
- code-reviewer: Twice per phase (after EXECUTE, final in VERIFY)
- code-simplifier: Once per phase (after EXECUTE)
- build-validator: Once per phase (after EXECUTE)
- verify-app: Once per phase (during VERIFY)

---

## Version Compatibility

**Tested with:**
- GSD v1.6.4
- Claude Code (latest)
- Boris Workflow Template v1.0.0

**Update policy:** Document GSD version in this file. Test before updating GSD to ensure compatibility.

---

## Customization

### Adding Custom Quality Gates

Edit this file to add your own checkpoints:

```markdown
### Custom Gate: Security Scan

**When:** After EXECUTE, before code-reviewer
**Agent:** None (manual Snyk scan)
**Prompt:** "Run security vulnerability scan with Snyk"
```

### Adjusting Agent Thresholds

Edit individual agent files in `.claude/agents/`:
- `code-reviewer.md` — Adjust confidence threshold
- `code-simplifier.md` — Adjust simplification aggressiveness

---

## References

- **GSD Repository:** [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done)
- **GSD Reference (cloned during planning):** `/tmp/gsd-reference/`
- **Boris Workflow:** [CLAUDE.md](../CLAUDE.md)
- **Comprehensive Guide:** [docs/GSD_INTEGRATION.md](../docs/GSD_INTEGRATION.md)

---

**Last Updated:** 2026-01-18
**Maintained by:** Boris Workflow Template project
