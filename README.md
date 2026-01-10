# Boris Workflow Template for Claude Code

A production-ready template implementing [Boris Cherny's Claude Code workflow](https://x.com/bcherny/status/2007179832300581177) — a systematic approach to AI-assisted development that delivers 2-3x quality improvement through verification loops.

## Overview

This template provides:

- **6 Specialized Agents** for code architecture, review, simplification, build validation, app verification, and incident response
- **4 Workflow Commands** for commits, PRs, code review, and feature development
- **Auto-formatting Hook** that runs on every file edit
- **Comprehensive CLAUDE.md** with coding standards and learning journal

## Quick Start

### Option 1: Clone and Customize

```bash
git clone https://github.com/KreativKI/Boris_Claude_Code.git my-project
cd my-project
rm -rf .git
git init
# Customize CLAUDE.md for your project
```

### Option 2: Copy to Existing Project

```bash
# Copy the .claude folder and CLAUDE.md to your project
cp -r Boris_Claude_Code/.claude your-project/
cp Boris_Claude_Code/CLAUDE.md your-project/
```

### Start Using

```bash
cd my-project
claude  # Opens Claude Code with Boris workflow active
```

## The Boris Workflow

```
EXPLORE → PLAN → CODE → VERIFY → SIMPLIFY → COMMIT
```

1. **Explore**: Read and understand existing code first
2. **Plan**: Design the approach (use `code-architect` agent for complex features)
3. **Code**: Implement the solution
4. **Verify**: Run tests, typecheck, lint (`build-validator` + `verify-app` agents)
5. **Simplify**: Clean up code (`code-simplifier` agent)
6. **Commit**: Use `/commit-push-pr` command

## Included Agents

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| `code-architect` | Designs feature architectures | Before implementing complex features |
| `code-reviewer` | Reviews code for bugs and issues | After writing code, before committing |
| `code-simplifier` | Cleans up code for readability | After code review passes |
| `build-validator` | Validates build, typecheck, lint, tests | Before committing any changes |
| `verify-app` | Verifies app functionality | After changes to confirm they work |
| `oncall-guide` | Incident response guidance | When production issues occur |

## Included Commands

| Command | Description |
|---------|-------------|
| `/commit-push-pr` | Full git workflow: commit, push, create PR |
| `/code-review` | Comprehensive PR code review |
| `/commit` | Simple git commit |
| `/feature-dev` | Guided feature development with architecture focus |

## Configuration Files

```
.claude/
├── agents/           # 6 agent definitions
│   ├── build-validator.md
│   ├── code-architect.md
│   ├── code-reviewer.md
│   ├── code-simplifier.md
│   ├── oncall-guide.md
│   └── verify-app.md
├── commands/         # 4 workflow commands
│   ├── code-review.md
│   ├── commit-push-pr.md
│   ├── commit.md
│   └── feature-dev.md
└── settings.json     # Permissions and hooks
CLAUDE.md             # Project instructions and standards
```

## Customization

### CLAUDE.md

Edit `CLAUDE.md` to add your project-specific:

- Build commands (npm, bun, yarn, etc.)
- Code style preferences
- Project-specific patterns
- Learned rules from mistakes

### settings.json

Modify `.claude/settings.json` to:

- Add/remove allowed commands
- Change the auto-format command
- Adjust permissions

## Key Features

### Auto-Formatting Hook

Every file edit automatically triggers formatting:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "bun run format || true"
      }]
    }]
  }
}
```

### Thinking Modes

Use these phrases to control reasoning depth:

| Phrase | Use Case |
|--------|----------|
| "think" | Quick logic outline |
| "think hard" | Step-by-step reasoning |
| "think harder" | Deep analysis with alternatives |
| "ultrathink" | Full architectural review |

### Learning Journal

The Meta-Rule in `CLAUDE.md` tracks mistakes and solutions:

```markdown
| Date | Mistake | Rule |
|------|---------|------|
| 2024-01-09 | Hook without error handling | Always use `|| true` in hook commands |
```

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed
- Node.js 18+ (for npm/bun commands)
- Git

## Sources

This template is based on verified sources:

| Source | Content |
|--------|---------|
| [Boris Cherny's Config](https://github.com/0xquinto/bcherny-claude) | build-validator, verify-app, oncall-guide agents |
| [Anthropic Plugins](https://github.com/anthropics) | code-architect, code-reviewer, code-simplifier agents |
| [Boris Cherny's X Thread](https://x.com/bcherny/status/2007179832300581177) | Original workflow specification |

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Acknowledgments

- **Boris Cherny** — Creator of Claude Code and the original workflow
- **Anthropic** — For Claude Code and the plugin ecosystem
