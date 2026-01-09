# Commit, Push, and Create PR

Execute the complete git workflow: analyze changes, commit, push, and create a pull request.

## Pre-Compute Context (Run These First)

```bash
export PATH="/Volumes/DevDrive/homebrew/bin:$PATH"
git status
```

```bash
git diff --stat
```

```bash
git diff
```

## Workflow Instructions

After reviewing the git status and diff output above, execute this workflow:

### 1. Analyze Changes
Based on the diff output, identify:
- What files changed
- What functionality was added/modified/fixed
- The appropriate commit type (feat/fix/docs/style/refactor/test/chore)

### 2. Generate Commit Message
Create a descriptive commit message following conventional commits format:

**Format:**
```
<type>: <short description>

<optional detailed body>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Commit Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `style:` - Formatting, no code change
- `refactor:` - Code restructuring
- `test:` - Adding tests
- `chore:` - Maintenance (deps, config, etc)

### 3. Execute Git Operations

```bash
# Stage all changes
git add .

# Commit with generated message using heredoc
git commit -m "$(cat <<'EOF'
<your generated commit message here>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

# Push to remote
git push -u origin HEAD

# Verify
git status
```

### 4. Create Pull Request

Generate a PR title and body, then create the PR:

```bash
gh pr create --draft --title "<descriptive PR title>" --body "$(cat <<'EOF'
## Summary

- <bullet point 1: key change>
- <bullet point 2: key change>
- <bullet point 3: key change>

## Changes Made

<more detailed description if needed>

## Test Plan

- [ ] <verification step 1>
- [ ] <verification step 2>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**Note:** Remove `--draft` flag if user wants a non-draft PR ready for immediate review.

### 5. Report Results

After completing all steps, provide:
1. ✅ **Commit:** `<commit hash>` - `<commit message>`
2. 🔗 **PR URL:** `<GitHub PR link>`
3. 📝 **Summary:** Brief description of what was committed

## Example Output

```
✅ Commit: a1b2c3d - feat: add visual verification with Playwright
🔗 PR: https://github.com/KreativKI/Boris_Claude_Code/pull/1
📝 Summary: Added Playwright setup and visual verification workflow for web files
```
