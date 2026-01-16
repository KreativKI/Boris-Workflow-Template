# Boris Workflow Template for Claude Code

A production-ready template implementing [Boris Cherny's Claude Code workflow](https://x.com/bcherny/status/2007179832300581177) — a systematic approach to AI-assisted development that delivers 2-3x quality improvement through verification loops.

## Overview

This template provides:

- **6 Specialized Agents** for code architecture, review, simplification, build validation, app verification, and incident response
- **4 Workflow Commands** for commits, PRs, code review, and feature development
- **Auto-formatting Hook** that runs on every file edit
- **Comprehensive CLAUDE.md** with coding standards and learning journal

## Quick Start

### Option 1: Copy Folder + Run Setup (Recommended)

```bash
# Copy the template folder (Finder or terminal)
cp -r boris_claude_code_template my-project
cd my-project

# Run the setup script (handles everything automatically)
./setup.sh
```

The setup script will:
- Remove the template's `.git` folder
- Initialize a fresh git repository
- Optionally set your remote URL and push
- Create initial commit
- Delete itself when done

### Option 2: Copy to Existing Project

```bash
# Copy ONLY the .claude folder and CLAUDE.md
cp -r Boris-Workflow-Template/.claude your-project/
cp Boris-Workflow-Template/CLAUDE.md your-project/
```

### Option 3: Clone from GitHub

```bash
git clone https://github.com/KreativKI/Boris-Workflow-Template.git my-project
cd my-project
./setup.sh
```

### Install Dependencies (One-Time Setup)

The template includes a smart auto-format hook. Install the formatter for your project type:

**For Python projects:**
```bash
pip install ruff
# Or install all dev dependencies:
pip install -r requirements-dev.txt
```

**For Node.js projects:**
```bash
npm install
# or
bun install
```

The hook auto-detects your project type and uses the appropriate formatter.

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

## Included Agents (Project-Local)

**These agents are already configured in `.claude/agents/` and work immediately without installation.**

Claude uses them via the Task tool:

| Agent | How Claude Uses It | When to Use |
|-------|-------------------|-------------|
| `code-architect` | `Task(subagent_type="code-architect")` | Before implementing complex features |
| `code-reviewer` | `Task(subagent_type="code-reviewer")` | After writing code, before committing |
| `code-simplifier` | `Task(subagent_type="code-simplifier")` | After code review passes |
| `build-validator` | `Task(subagent_type="build-validator")` | Before committing any changes |
| `verify-app` | `Task(subagent_type="verify-app")` | After changes to confirm they work |
| `oncall-guide` | `Task(subagent_type="oncall-guide")` | When production issues occur |

**User prompt examples:**
- "Use code-architect to design this feature"
- "Run build-validator before I commit"
- "Use verify-app to test my changes"

## Included Commands (Project-Local)

**These slash commands are already configured in `.claude/commands/` and work immediately.**

| Command | How to Use | Description |
|---------|-----------|-------------|
| `/commit` | Type `/commit` | Create a git commit with current changes |
| `/commit-push-pr` | Type `/commit-push-pr` | Full workflow: commit → push → create PR |
| `/code-review` | Type `/code-review` | Comprehensive code review of changes |
| `/feature-dev` | Type `/feature-dev` | Guided feature development workflow |

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
├── hooks/            # Auto-run scripts
│   └── auto-format.sh  # Smart formatter (Python/Node/Rust/Go)
└── settings.json     # Permissions and hooks
CLAUDE.md             # Project instructions and standards
requirements-dev.txt  # Python dev dependencies (ruff, pytest, mypy)
package.json          # Node.js dev dependencies
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

### Smart Auto-Formatting Hook

Every file edit automatically triggers formatting via `.claude/hooks/auto-format.sh`:

```bash
# Auto-detects project type and runs appropriate formatter:
# - Python: ruff format (or black)
# - Node.js: bun run format (or npm run format)
# - Rust: cargo fmt
# - Go: gofmt
```

The hook is configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/auto-format.sh || true"
      }]
    }]
  }
}
```

**Important:** Install the formatter for your project type (see Quick Start above).

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
- Git

**For Python projects:**
- Python 3.10+
- ruff (install via `pip install ruff`)

**For Node.js projects:**
- Node.js 18+ or Bun
- Run `npm install` or `bun install`

## Recommended Global Plugins (Optional)

**Note:** The template includes local agents and commands that work immediately. These plugins are **optional enhancements** for additional functionality.

Install these plugins globally (one-time setup):

```bash
# Boris's most-used plugins
claude plugin add ralph-loop@claude-plugins-official      # Autonomous loops for long tasks
claude plugin add commit-commands@claude-plugins-official # Enhanced git workflow
claude plugin add feature-dev@claude-plugins-official     # Guided feature development
claude plugin add pr-review-toolkit@claude-plugins-official # Advanced PR review

# Optional
claude plugin add agent-sdk-dev@claude-code-plugins       # For building Agent SDK apps
```

### Plugin Quick Reference

| Plugin | Command | When to Use |
|--------|---------|-------------|
| `ralph-loop` | `/ralph-loop:ralph-loop "task"` | Long autonomous tasks with clear completion criteria (Boris's secret weapon) |
| `commit-commands` | `/commit-commands:commit-push-pr` | Enhanced git workflow (similar to local `/commit-push-pr`) |
| `feature-dev` | Structured feature development |
| `pr-review-toolkit` | Thorough PR review before merge |
| `agent-sdk-dev` | Creating new Claude Agent SDK applications |

See the "What Boris Would Do" section in `CLAUDE.md` for detailed usage guidance.

## Sources

This template is based on verified sources:

| Source | Type | Content |
|--------|------|---------|
| [Boris Cherny's X Thread](https://x.com/bcherny/status/2007179832300581177) | **OFFICIAL** | Original workflow specification |
| [Boris Cherny's GitHub](https://github.com/bcherny) | **OFFICIAL** | His actual GitHub account |
| [Anthropic Plugins](https://github.com/anthropics) | Official | code-architect, code-reviewer, code-simplifier agents |
| [Community repo (0xquinto)](https://github.com/0xquinto/bcherny-claude) | Community | build-validator, verify-app, oncall-guide agents |

**Note:** The 0xquinto repo is a community interpretation, NOT Boris Cherny's official repo.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Acknowledgments

- **Boris Cherny** — Creator of Claude Code and the original workflow
- **Anthropic** — For Claude Code and the plugin ecosystem
