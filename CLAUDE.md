# Boris Claude Code Configuration
**Based on:** Boris Cherny's Claude Code Workflow Specification
**Purpose:** Agent's "Living Memory" to prevent Context Amnesia and compound knowledge over time

---

## Bash Commands

Standard Node.js build and test commands:

```bash
# Build
npm run build

# Type checking
npm run typecheck

# Linting
npm run lint

# Testing
npm run test

# Development server
npm run dev

# Format code
npm run format
```

---

## Code Style

- **Use ES modules** (`import`/`export`) instead of CommonJS (`require`/`module.exports`)
- **Destructure imports** where possible
- **Use TypeScript** for type safety
- **Prefer `const`** over `let`; avoid `var`
- **Use async/await** over raw Promises
- **Keep functions small** and single-purpose

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
5. **Commit:** Use slash commands to commit and push

---

## Meta-Rule

**Every time Claude makes a mistake, add a rule to this file so it doesn't happen again.**

This is how the agent learns and improves over time. Document:
- What went wrong
- The new rule to prevent it
- Date added

### Learned Rules
*(Add new rules here as mistakes occur)*

| Date | Mistake | Rule |
|------|---------|------|
| YYYY-MM-DD | [Description of mistake] | [New rule to prevent it] |

---

## References

- Original workflow: [Boris Cherny's X post](https://x.com/bcherny/status/2007179832300581177)

---

## Git Workflow

• Branch First: Never commit directly to main. Before starting work, check the branch. If on main, create a new feature branch (e.g., feature/description).
• Commit Often: When a step is complete and verified, use the /commit-push-pr slash command.

---

## Thinking Modes

• "think": Outline the logic briefly.
• "think hard": Step-by-step reasoning for complex logic.
• "think harder": More exhaustive analysis with deeper exploration of alternatives.
• "ultrathink": Full architectural review, edge-case analysis, and security implications before planning.
