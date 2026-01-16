# Boris Workflow Template — CLAUDE.md

**Based on:** Boris Cherny's Claude Code Workflow  
**Purpose:** Agent's "Living Memory" to prevent Context Amnesia and compound knowledge over time  
**Template Version:** 1.0.0

---

## Development Workflow

**Always use `bun`, not `npm`.**

```bash
# 1. Make changes

# 2. Typecheck (fast)
bun run typecheck

# 3. Run tests
bun run test -- -t "test name"      # Single suite
bun run test:file -- "glob"         # Specific files

# 4. Lint before committing
bun run lint:file -- "file1.ts"     # Specific files
bun run lint                        # All files

# 5. Before creating PR
bun run lint:claude && bun run test
```

---

## Bash Commands

### Build & Test
| Command | Description |
|---------|-------------|
| `bun run build` | Build the project |
| `bun run dev` | Start development server |
| `bun run test` | Run all tests |
| `bun run test:file -- "pattern"` | Run specific test files |
| `bun run typecheck` | Run TypeScript type checker |

### Code Quality
| Command | Description |
|---------|-------------|
| `bun run lint` | Lint all files |
| `bun run lint:file -- "file"` | Lint specific file |
| `bun run format` | Format all code |

### Git Workflow
| Command | Description |
|---------|-------------|
| `git status` | Check working tree status |
| `git diff` | View unstaged changes |
| `git log -n 5` | View recent commits |
| `gh pr create --draft` | Create draft PR |
| `gh pr view` | View current PR |

---

## Code Style

### General Principles
- **Use ES modules** (`import`/`export`) instead of CommonJS (`require`/`module.exports`)
- **Destructure imports** where possible: `import { useState } from 'react'`
- **Use TypeScript** for type safety
- **Prefer `const`** over `let`; avoid `var`
- **Use async/await** over raw Promises
- **Keep functions small** and single-purpose (max ~50 lines)

### Naming Conventions
| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userName`, `isLoading` |
| Functions | camelCase, verb prefix | `getUserData`, `handleClick` |
| Components | PascalCase | `UserProfile`, `NavBar` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRIES`, `API_URL` |
| Types/Interfaces | PascalCase | `UserData`, `ApiResponse` |
| Files (components) | PascalCase | `UserProfile.tsx` |
| Files (utilities) | camelCase | `formatDate.ts` |

### File Organization
```
src/
├── components/          # React components
│   └── ComponentName/
│       ├── index.ts     # Public exports
│       ├── ComponentName.tsx
│       ├── ComponentName.test.tsx
│       └── types.ts
├── hooks/               # Custom hooks
├── utils/               # Utility functions
├── types/               # Shared type definitions
└── services/            # API and external services
```

---

## UI & Content Design Guidelines

### Visual Design Principles
1. **Consistency** — Use design tokens for colors, spacing, typography
2. **Hierarchy** — Clear visual hierarchy guides the eye
3. **Whitespace** — Generous spacing improves readability
4. **Feedback** — Every interaction should have visible feedback

### Accessibility Requirements
- All images need `alt` text
- Interactive elements need focus states
- Color contrast ratio minimum 4.5:1
- Keyboard navigation must work
- ARIA labels for non-obvious UI

### Component Guidelines
- Prefer composition over configuration props
- Keep components focused (single responsibility)
- Extract reusable logic into custom hooks
- Use semantic HTML elements

### Content Guidelines
- Use clear, concise language
- Avoid jargon unless necessary
- Error messages should be helpful, not technical
- Labels should describe the action, not the element

---

## State Management

### Where State Should Live
| State Type | Location | Example |
|------------|----------|---------|
| Component-local | `useState` | Form input values |
| Shared UI state | Context or Zustand | Theme, sidebar open |
| Server state | React Query / SWR | API data |
| URL state | URL params | Filters, pagination |
| Form state | React Hook Form | Complex forms |

### Principles
1. **Lift state only when needed** — Keep state as local as possible
2. **Single source of truth** — Don't duplicate state
3. **Derive when possible** — Calculate values instead of storing them
4. **Immutable updates** — Never mutate state directly

### Patterns
```typescript
// ✅ Good - Derived state
const filteredItems = items.filter(item => item.active);

// ❌ Bad - Duplicate state
const [items, setItems] = useState([]);
const [filteredItems, setFilteredItems] = useState([]); // Redundant
```

---

## Logging Guidelines

### Log Levels
| Level | When to Use | Example |
|-------|-------------|---------|
| `debug` | Development details | `debug('Rendering component', { props })` |
| `info` | Normal operations | `info('User logged in', { userId })` |
| `warn` | Potential issues | `warn('API slow', { duration })` |
| `error` | Errors that need attention | `error('Payment failed', { error })` |

### What to Log
- **Do log:** User actions, API calls, errors, performance metrics
- **Don't log:** Sensitive data (passwords, tokens, PII)

### Structured Logging Format
```typescript
logger.info('Operation completed', {
  operation: 'createUser',
  userId: user.id,
  duration: Date.now() - startTime,
});
```

---

## Error Handling

### Error Types
| Type | Handling | User Message |
|------|----------|--------------|
| Validation | Return error, don't throw | "Please enter a valid email" |
| Network | Retry with backoff | "Connection issue. Retrying..." |
| Auth | Redirect to login | "Please sign in to continue" |
| Server | Log and show generic | "Something went wrong. Try again." |
| Unexpected | Log, alert, generic message | "An error occurred" |

### Patterns
```typescript
// ✅ Good - Typed error handling
try {
  await api.createUser(data);
} catch (error) {
  if (error instanceof ValidationError) {
    return { errors: error.fields };
  }
  if (error instanceof NetworkError) {
    toast.error('Connection issue. Please try again.');
    return;
  }
  // Unexpected error - log and rethrow
  logger.error('Unexpected error in createUser', { error });
  throw error;
}
```

### User-Facing Errors
- Be helpful, not technical
- Suggest what to do next
- Provide a way to retry or get help

---

## Gating Guidelines

### Feature Flags
Use feature flags for:
- New features in development
- A/B testing
- Gradual rollouts
- Kill switches for risky features

### Implementation Pattern
```typescript
// Check flag before rendering
if (featureFlags.isEnabled('new-dashboard')) {
  return <NewDashboard />;
}
return <OldDashboard />;
```

### Rollout Strategy
1. **Development** — Flag off by default
2. **Internal testing** — Enable for team
3. **Beta** — Enable for opt-in users
4. **Gradual rollout** — 10% → 50% → 100%
5. **Cleanup** — Remove flag after full rollout

---

## Debugging Guidelines

### Tools
| Tool | Purpose |
|------|---------|
| Browser DevTools | Network, console, elements |
| React DevTools | Component tree, state |
| VS Code debugger | Breakpoints, step through |
| `console.log` | Quick inspection (remove before commit!) |

### Common Debugging Patterns
```typescript
// Temporary debug logging (use sparingly, remove before commit)
console.log('[DEBUG]', { variable, state, props });

// Conditional breakpoint in code
if (condition) debugger;

// Performance timing
console.time('operation');
await doExpensiveWork();
console.timeEnd('operation');
```

### Debugging Checklist
1. Can I reproduce the issue?
2. What changed recently?
3. What do logs/errors say?
4. Is it environment-specific?
5. Can I write a test that fails?

---

## Pull Request Template

When creating PRs, use this structure:

```markdown
## Summary
Brief description of what this PR does.

## Changes
- Bullet point of key changes
- Another change
- Another change

## Test Plan
- [ ] Unit tests pass
- [ ] Manual testing steps
- [ ] Verified in browser (if UI)

## Screenshots (if applicable)
[Before/after screenshots for UI changes]

## Notes for Reviewers
Any context that helps reviewers understand the PR.
```

---

## Workflow Rules

### Explain First
Before writing code, briefly explain your plan. This ensures alignment and catches logical errors early.

### Visual Verification
**CRITICAL:** After creating any HTML/Web file, you MUST use Playwright to verify it renders correctly.

The feedback loop:
1. Write Code
2. Open Browser (via Playwright)
3. Analyze Visuals (screenshot)
4. Fix Code (if needed)

This delivers a 2-3x quality improvement over blind coding.

### The Inner Loop
Follow the "Explore, Plan, Code, Commit" sequence:
1. **Explore:** Read relevant files first ("don't write code yet")
2. **Plan:** Use Plan Mode (Shift+Tab twice) for complex problems
3. **Code:** Implement the solution
4. **Verify:** Use Playwright to take screenshots or run tests
5. **Commit:** Use `/commit-push-pr` skill when ready

---

## Git Workflow

- **Branch First:** Never commit directly to main. Create a feature branch first.
- **Commit Often:** When a step is complete and verified, commit it.
- **Conventional Commits:** Use `feat:`, `fix:`, `docs:`, `refactor:`, etc.

---

## Available Plugins & When to Use Them

### Globally Installed Plugins

Install these plugins globally for enhanced workflow:

```bash
# Install recommended plugins
claude plugin add ralph-loop@claude-plugins-official
claude plugin add agent-sdk-dev@claude-code-plugins
claude plugin add commit-commands@claude-plugins-official
claude plugin add feature-dev@claude-plugins-official
claude plugin add pr-review-toolkit@claude-plugins-official
```

### Plugin Reference

| Plugin | Use When | Command/Usage |
|--------|----------|---------------|
| `ralph-loop` | Long-running iterative tasks with clear completion criteria | `/ralph-loop:ralph-loop "prompt" --max-iterations 50` |
| `agent-sdk-dev` | Creating new Claude Agent SDK applications | `/agent-sdk-dev:new-sdk-app project-name` |
| `commit-commands` | Git workflow (commit, push, PR) | `/commit-commands:commit-push-pr` |
| `feature-dev` | Guided feature development with architecture focus | `/feature-dev:feature-dev` |
| `pr-review-toolkit` | Comprehensive PR review with multiple specialized agents | `/pr-review-toolkit:review-pr` |

### When to Use Each Plugin

**`ralph-loop`** - The "Ralph Wiggum" technique for autonomous iteration:
- Tasks with clear, testable completion criteria
- Greenfield projects you can walk away from
- Tasks requiring multiple iterations (tests, refinement)
- NOT for tasks requiring human judgment or design decisions

**`agent-sdk-dev`** - For building Claude Agent SDK applications:
- Creating new agents in Python or TypeScript
- Scaffolding with best practices
- Automatic verification of SDK setup

**`feature-dev`** - Guided feature development:
- New features requiring architecture planning
- Complex implementations spanning multiple files
- When you want structured guidance through the process

**`pr-review-toolkit`** - Comprehensive code review:
- Before merging PRs
- Multi-aspect review (code quality, tests, error handling, types)
- When you want thorough automated review

---

## What Boris Would Do

Quick reference for applying the Boris Cherny workflow to common situations:

### Starting a New Feature

```
1. git checkout -b feature/name
2. Use Plan Mode (Shift+Tab twice) to design approach
3. /feature-dev:feature-dev "feature description"
4. Run code-reviewer agent after implementation
5. Run code-simplifier agent to clean up
6. /commit-commands:commit-push-pr
```

### Long Autonomous Task

```
1. Define clear completion criteria
2. /ralph-loop:ralph-loop "Build X. Requirements: Y, Z. Output <promise>DONE</promise> when complete." --max-iterations 50 --completion-promise "DONE"
3. Walk away, let it iterate
4. Review results when complete
```

### Creating an Agent SDK App

```
1. /agent-sdk-dev:new-sdk-app my-agent
2. Follow interactive prompts (language, type, etc.)
3. Verifier agent runs automatically
4. Start building your agent logic
```

### Quick Reference Table

| Situation | Boris Approach |
|-----------|----------------|
| Starting new feature | Plan Mode → `/feature-dev` → code-reviewer → code-simplifier → commit |
| Long autonomous task | `/ralph-loop` with clear completion criteria |
| Creating Agent SDK app | `/agent-sdk-dev:new-sdk-app` |
| Code review | Run code-reviewer agent (confidence ≥80%) |
| Before PR | build-validator agent → verify-app agent |
| After writing code | code-simplifier agent |
| Complex architecture | code-architect agent |
| Production incident | oncall-guide agent |

---

## Thinking Modes

Use these phrases to trigger different levels of reasoning:

| Phrase | Use When |
|--------|----------|
| "think" | Outline logic briefly |
| "think hard" | Step-by-step reasoning for complex logic |
| "think harder" | Exhaustive analysis with alternatives |
| "ultrathink" | Full architectural review, edge-cases, security |

---

## Skills & Agents Policy

### No Edit Downloaded Skills/Agents Rule

**STRICT POLICY: Never edit downloaded skills, agents, or plugins without explicit user permission.**

Reasoning:
- Downloaded skills have been crafted and tested by their authors
- Edits cannot be verified by non-programmer users
- The skill may already exist in a different form - check first
- Modifications break the trust chain of curated content

**Before modifying ANY skill/agent file:**
1. STOP and notify the user with a clear explanation of why the edit is needed
2. Wait for explicit approval
3. If the user declines, suggest alternatives (e.g., creating a new skill instead)

**Before creating custom skills/agents:**
1. Check official sources: `~/.claude/plugins/cache/`
2. Check user's skills library (if configured)
3. Check project-local `.claude/skills/` and `.claude/agents/`
4. Only create new if nothing suitable exists

---

## Meta-Rule

**Every time Claude makes a mistake, add a rule to this file so it doesn't happen again.**

This is how the agent learns and improves over time. Document:
- What went wrong
- The new rule to prevent it
- Date added

### Learned Rules

| Date | Mistake | Rule |
|------|---------|------|
| 2026-01-09 | Almost created custom subagent when official one exists | Always check plugin marketplace before creating custom tools. |
| 2026-01-09 | PostToolUse hook without error handling could block edits | Always use `\|\| true` in hook commands to prevent failures. |
| 2026-01-09 | Assumed HTML renders correctly without verification | Always use Playwright visual verification for web content. |
| 2026-01-09 | Created custom subagents without checking official sources | **NEVER create subagents or skills without first checking official Anthropic sources** (`~/.claude/plugins/marketplaces/claude-plugins-official/`). Use official templates as base. |
| 2026-01-12 | Attempted to edit downloaded agent files without permission | **NEVER edit downloaded skills/agents without explicit user notification and approval.** |

---

## References

- [Boris Cherny's X post](https://x.com/bcherny/status/2007179832300581177)
- [Claude Code Documentation](https://code.claude.com/docs/en/overview)
- [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
