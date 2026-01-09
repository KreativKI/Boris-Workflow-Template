# Boris Cherny's Claude Code Workflow Specification

## 1. Core Philosophy: The "Vibe Coding" Paradigm
The goal of this workflow is to establish a "Zero-to-One" Agentic Environment where the user acts as an architect rather than a typist [1]. The workflow relies on "Vibe Coding," where the primary skill is articulating intent and evaluating outcomes rather than rote syntax memorization [2].

The 3-Part "Cherny Method" for quality and speed:
1.  **Parallel Execution:** Run multiple instances (tabs) of Claude to manage parallel work streams [3].
2.  **Epistemic Security:** Use "Plan Mode" to verify logic before execution [4].
3.  **Visual Verification:** Use Playwright to give Claude "eyes" to verify its own work, which delivers a 2-3x quality improvement [5].

## 2. The Constitution: CLAUDE.md
The repository must contain a `CLAUDE.md` file in the root, acting as the agent's "Living Memory" [6]. This file prevents "Context Amnesia" and compounds knowledge over time [7].

**Required Sections for CLAUDE.md:**
*   **Bash Commands:** List standard build/test commands (e.g., `npm run build`, `npm run typecheck`) [8].
*   **Code Style:** Explicit rules (e.g., "Use ES modules," "Destructure imports") [8].
*   **Workflow Rules:** 
    *   "Explain First: Before writing code, briefly explain your plan." [9].
    *   "Visual Verification: After creating any HTML/Web file, you MUST use Playwright to verify it renders." [10].
*   **Meta-Rule:** "Every time Claude makes a mistake, add a rule to CLAUDE.md so it doesn’t happen again." [11].

## 3. The "Inner Loop" Workflow
Boris Cherny’s specific "Explore, Plan, Code, Commit" loop must be followed [12]:
1.  **Explore:** Ask Claude to read relevant files explicitly saying "don't write code yet" [13].
2.  **Plan Mode:** Access by pressing Shift+Tab twice. Use "think" or "ultrathink" for complex problems [12]. Iterate until the plan is solid.
3.  **Code:** Ask Claude to implement the solution.
4.  **Verify:** Use Playwright to take screenshots or run tests [14].
5.  **Commit:** Use slash commands to commit and push [15].

## 4. Configuration & Nervous System
*   **Permissions:** Do NOT use `--dangerously-skip-permissions` globally. Instead, create a `.claude/settings.json` file to whitelist specific safe commands (like `ls`, `git status`, `npm run *`) [16].
*   **Slash Commands:** Automate repeated workflows (like `/commit-push-pr`) by storing them in `.claude/commands/` [15]. These commands should use inline bash to pre-compute context (e.g., checking git status before asking the model) [15].
*   **Hooks:** Implement a "PostToolUse" hook in `settings.json` to automatically format code (e.g., `bun run format`) after Claude edits files [17].

## 5. Tooling: The Senses
*   **Playwright MCP:** Must be installed to allow Claude to navigate websites, click elements, and take screenshots [14]. This creates the critical feedback loop: Write Code -> Open Browser -> Analyze Visuals -> Fix Code [14].

## 6. See also the original Boris post here: https://x.com/bcherny/status/2007179832300581177?s=43
