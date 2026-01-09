# Boris Cherny's Claude Code workflow: A complete guide from the creator

**Boris Cherny, the creator of Claude Code at Anthropic, publicly shared his workflow in January 2026, revealing that his setup is "surprisingly vanilla."** The core insight from his 13-part thread on X: Claude Code works exceptionally well out of the box, and the secret to maximum productivity lies not in exotic customization but in disciplined application of fundamentals—particularly giving Claude a way to **verify its own work**, which he says delivers a **2-3x quality improvement**.

In 30 days, Boris landed **259 pull requests**—497 commits, 40,000 lines added, 38,000 lines removed—with every single line written by Claude Code using Opus 4.5. At Anthropic, 80-90% of the Claude Code codebase was written using Claude Code itself, and the tool has driven a **70% productivity increase** per engineer company-wide.

## Running multiple Claude sessions in parallel is foundational

Boris operates **five Claude Code instances simultaneously** in his terminal, numbered 1-5 in separate tabs. Each tab runs in its own git checkout of the same repository, allowing Claude to make changes in parallel without conflicts. He uses iTerm2 system notifications to know when any session needs input, so he can work on other things while Claude operates.

Beyond terminal sessions, he runs **5-10 additional sessions on claude.ai/code** in parallel with his local instances. He frequently hands off sessions between local and web environments using the `--teleport` command, and even starts sessions from his phone using the Claude iOS app every morning, checking on them later. This parallelization strategy is key: multiple simple sessions beat one overloaded session.

For model selection, Boris exclusively uses **Opus 4.5 with thinking enabled** for everything. Despite being larger and slower than Sonnet, he finds it requires less steering and excels at tool use, making it faster overall. The specific phrases that trigger increasing thinking levels are: "think" < "think hard" < "think harder" < "ultrathink".

## The CLAUDE.md file compounds knowledge across your team

The Claude Code team maintains a **single shared CLAUDE.md file** checked into git for their repository. The entire team contributes multiple times per week, and critically: **every time Claude makes a mistake, they add a rule to CLAUDE.md** so it doesn't happen again. This creates compounding value over time.

CLAUDE.md is a special configuration file that Claude automatically loads at startup. It can live in several locations:
- **Root of your repo** (`./CLAUDE.md`)—most common, shared with team via git
- **Home folder** (`~/.claude/CLAUDE.md`)—applies to all your sessions
- **Parent directories**—automatically loaded when working in subdirectories
- **Child directories**—loaded on-demand when working with those files
- **Rules directory** (`.claude/rules/*.md`)—for organized additional rules

A well-structured CLAUDE.md should include bash commands Claude can use, code style guidelines, testing instructions, repository etiquette, and project-specific warnings. Here's an example structure:

```markdown
# Bash commands
- npm run build: Build the project
- npm run typecheck: Run the typechecker

# Code style
- Use ES modules (import/export) syntax, not CommonJS (require)
- Destructure imports when possible

# Workflow
- Be sure to typecheck when you're done making code changes
- Prefer running single tests, not the whole test suite
```

During code review, Boris tags **@.claude on coworkers' pull requests** to add CLAUDE.md updates as part of the PR itself. They use the Claude Code GitHub Action (installed via `/install-github-action`) for this integration—turning code review into an opportunity for continuous AI improvement.

## Plan Mode is where every serious session begins

Most of Boris's sessions start in **Plan Mode**, accessed by pressing **Shift+Tab twice**. When his goal is to write a pull request, he uses Plan Mode to go back and forth with Claude until he likes its plan. Only then does he switch to auto-accept edits mode, at which point Claude can usually "one-shot" the execution. His emphatic advice: "A good plan is really important!"

The recommended workflow Boris calls "Explore, Plan, Code, Commit" works like this:
1. Ask Claude to read relevant files (explicitly say "don't write code yet")
2. Ask Claude to make a plan (use "think" or "ultrathink" for complex problems)
3. Ask Claude to implement the solution
4. Ask Claude to commit and create a pull request

For test-driven development, the pattern becomes: write tests based on expected input/output, have Claude confirm they fail, commit the tests, then have Claude write code to pass them without modifying the tests.

A crucial tip from podcast interviews: **ask Claude to ask you questions**. Claude doesn't naturally do this, but in Plan Mode you can tell it "we're brainstorming—please ask me questions if anything is unclear." This dramatically improves the resulting plan quality.

## Slash commands automate your most repeated workflows

Boris uses slash commands for every "inner loop" workflow he performs many times per day. Commands are stored in `.claude/commands/` and checked into git so the whole team can use them. His most-used command, `/commit-push-pr`, runs **dozens of times every day**.

The key innovation: commands can include **inline bash to pre-compute context** (like git status) to avoid unnecessary back-and-forth with the model. For example, a fix-github-issue command might look like:

```markdown
Please analyze and fix the GitHub issue: $ARGUMENTS.

Follow these steps:
1. Use `gh issue view` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR
```

Usage would be `/project:fix-github-issue 1234`. Other commands Boris mentions using include `/commit`, `/PR`, `/feature-dev` (walks through building something step-by-step), `/security-review` for all PRs, and `/code-review` for automated code review.

## Subagents handle specialized automated workflows

Boris uses several subagents regularly, thinking of them as automating the most common workflows for most PRs:

| Subagent | Purpose |
|----------|---------|
| `code-simplifier` | Simplifies code after Claude is done working |
| `verify-app` | Detailed instructions for testing Claude Code end-to-end |
| `build-validator` | Build validation |
| `code-architect` | Architecture planning tasks |
| `oncall-guide` | Oncall-related automation |
| `planner` | Planning complex tasks |

Subagent files live in `.claude/agents/` (project) or `~/.claude/agents/` (personal). A subagent file might look like:

```yaml
---
name: code-simplifier
description: Simplify code after Claude is done working
tools: Read, Edit, Grep, Glob
model: inherit
---
You are a code simplification expert. Your goal is to make code more readable and maintainable without changing functionality.

Simplification principles:
- Reduce complexity and nesting
- Extract repeated logic into functions
- Use meaningful variable names
```

For large migrations, teams use a map-reduce pattern: a main agent creates a big to-do list, then distributes work across multiple subagents to handle different parts in parallel.

## Hooks automate formatting and verification automatically

Boris uses a **PostToolUse hook to automatically format code** after Claude writes or edits files. While Claude generates well-formatted code about 90% of the time, the hook handles the remaining 10% to prevent CI failures later:

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

For long-running tasks, Boris uses **Stop hooks** for deterministic verification—essentially telling Claude "if the tests don't pass, keep going." This creates autonomous agents that iterate until tasks are complete.

Hook configuration goes in `.claude/settings.json` for team-shared hooks or `~/.claude/settings.json` for personal hooks. Available hook events include PreToolUse, PostToolUse, PermissionRequest, UserPromptSubmit, Stop, SessionStart, SessionEnd, and PreCompact.

## Permission management avoids dangerous shortcuts

**Boris explicitly does not use `--dangerously-skip-permissions`** in normal development. Instead, he uses the `/permissions` command to pre-allow common bash commands that are safe in his environment. Most of these permissions are checked into `.claude/settings.json` and shared with the team:

```
/permissions
Permissions:
Allow  Ask  Deny
Workspace Claude Code won't ask before using allowed tools.
↑ 12. Bash(bq query:*)
13. Bash(bun run build:*)
14. Bash(bun run lint:file:*)
15. Bash(bun run test:*)
16. Bash(bun run test:file:*)
17. Bash(bun run typecheck:*)
```

This approach is safer than a blanket permission skip and faster than answering constant prompts. For long-running autonomous tasks run in a sandbox environment, he will use `--permission-mode=dontAsk` or `--dangerously-skip-permissions` to let Claude "cook" uninterrupted.

## MCP servers connect Claude to all your tools

Claude Code integrates with external tools via MCP (Model Context Protocol) servers. Boris has Claude use his tools directly:
- **Slack** via MCP server—for searching channels and posting messages
- **BigQuery** via bq CLI—for analytics queries
- **Sentry**—for grabbing error logs

The Slack MCP configuration is checked into `.mcp.json` and shared with the team:

```json
{
  "mcpServers": {
    "slack": {
      "type": "http",
      "url": "https://slack.mcp.anthropic.com/mcp"
    }
  }
}
```

To add MCP servers via command line:
```bash
# Remote HTTP server
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Local stdio server  
claude mcp add playwright npx @playwright/mcp@latest
```

Popular MCP servers include GitHub, Sentry, Notion, PostgreSQL, Playwright (browser automation), and filesystem access. On-demand tool loading means tools are available without consuming context until invoked.

## Verification is the single most important practice

Boris's most emphatic recommendation: **"Give Claude a way to verify its work. If Claude has that feedback loop, it will 2-3x the quality of the final result."**

Claude tests every single change Boris lands to claude.ai/code using the **Claude Chrome extension**. It opens a browser, tests the UI, and iterates until the code works and the UX feels good. Verification looks different for each domain:

| Complexity | Verification method |
|------------|---------------------|
| Simple | Running a bash command |
| Moderate | Running a test suite |
| Complex | Testing in a browser or phone simulator |

The investment in verification infrastructure pays dividends across every task. This is why hooks and subagents focused on verification (like `verify-app`) are so valuable.

## Long-running autonomous tasks require special handling

For very long-running tasks, Boris uses three approaches:
1. **Prompt Claude to verify** its work with a background agent when done
2. **Use an agent Stop hook** for more deterministic verification
3. **Use the ralph-wiggum plugin** (named after the Simpsons character) for autonomous loops

The ralph-wiggum plugin enables Claude to run continuously until a task is complete. Combined with permission bypassing in a sandbox, this creates fully autonomous agents. Plugin repository: `https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-wiggum`

## Key warnings and common pitfalls to avoid

Based on Boris's advice and community analysis:

- **Over-automation too early**: Start with one command or one hook, not ten. Add complexity gradually.
- **Skipping verification**: If you can't verify Claude's work, you're gambling on quality.
- **Messy parallelism**: Label sessions clearly and keep tasks independent to avoid confusion.
- **Bloated CLAUDE.md files**: Keep them short and review regularly. Only essential per-session information belongs there.
- **Using old mental models**: Newer developers who don't assume what Claude can't do often get better results. Models improve rapidly—what failed six months ago may work now.
- **Manual work Claude could do**: Boris regularly catches himself starting tasks manually, then remembers "Claude can probably do this" and hands it off.

## Essential resources and documentation

| Resource | URL |
|----------|-----|
| Claude Code main documentation | https://code.claude.com/docs/en/overview |
| Best practices (Anthropic official) | https://www.anthropic.com/engineering/claude-code-best-practices |
| Slash commands guide | https://code.claude.com/docs/en/slash-commands |
| Subagents documentation | https://code.claude.com/docs/en/sub-agents |
| Hooks guide | https://code.claude.com/docs/en/hooks-guide |
| Terminal notifications (iTerm2) | https://code.claude.com/docs/en/terminal-config#iterm-2-system-notifications |
| Chrome extension | https://code.claude.com/docs/en/chrome |
| Plugins | https://anthropic.com/news/claude-code-plugins |
| Boris's original thread | https://x.com/bcherny/status/2007179832300581177 |
| Boris's interview (Every.to) | https://every.to/podcast/transcript-how-to-use-claude-code-like-the-people-who-built-it |
| Boris's interview (Peterman Podcast) | https://www.developing.dev/p/boris-cherny-creator-of-claude-code |

## Conclusion

Boris Cherny's workflow reveals a counterintuitive truth: the creator of Claude Code uses an almost "vanilla" setup. The power comes not from clever hacks but from disciplined fundamentals—Plan Mode for every non-trivial task, shared CLAUDE.md that compounds learnings, verification loops that multiply quality, and parallelization that multiplies throughput.

For beginners, the starting point is clear: use Plan Mode (Shift+Tab twice) before writing code, create a CLAUDE.md file that captures what Claude should know about your project, and most importantly, give Claude a way to verify its work. Everything else—subagents, hooks, MCP servers, slash commands—builds on this foundation.

Half of Anthropic's sales team now uses Claude Code for their work by connecting it to Salesforce and other data sources. The VS Code extension removes terminal complexity entirely. The barrier to entry has never been lower, and Boris's workflow provides a proven template for getting maximum value from the tool he created.