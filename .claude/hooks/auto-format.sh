#!/bin/bash
# Auto-format hook for Boris Workflow Template
# Detects project type and runs appropriate formatter
# Called by PostToolUse hook after Write/Edit operations

# Silently exit on any error (don't block Claude)
set -e

# Detect project type and format accordingly
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    # Python project
    if command -v ruff &> /dev/null; then
        ruff format --quiet . 2>/dev/null || true
        ruff check --fix --quiet . 2>/dev/null || true
    elif command -v black &> /dev/null; then
        black --quiet . 2>/dev/null || true
    fi
elif [ -f "package.json" ]; then
    # Node.js project
    if command -v bun &> /dev/null; then
        bun run format 2>/dev/null || true
    elif command -v npm &> /dev/null; then
        npm run format 2>/dev/null || true
    fi
elif [ -f "Cargo.toml" ]; then
    # Rust project
    if command -v cargo &> /dev/null; then
        cargo fmt --quiet 2>/dev/null || true
    fi
elif [ -f "go.mod" ]; then
    # Go project
    if command -v gofmt &> /dev/null; then
        gofmt -w . 2>/dev/null || true
    fi
fi

# Always exit successfully (never block Claude)
exit 0
