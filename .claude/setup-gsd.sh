#!/bin/bash
# Boris Workflow + GSD Integration Setup Script
# Version: 1.0.0
# Purpose: One-command installation of Get-Shit-Done for multi-week projects

set -e  # Exit on error

echo "🎬 Boris Workflow + GSD Integration Setup"
echo "=========================================="
echo ""
echo "This script will install Get-Shit-Done (GSD) for multi-week project orchestration."
echo "Boris Workflow will continue to work standalone for smaller tasks."
echo ""
echo "What GSD adds:"
echo "  • Project orchestration (phases, milestones)"
echo "  • Atomic task breakdown (prevents context rot)"
echo "  • Parallel execution (fresh 200k context per task)"
echo "  • Systematic verification checkpoints"
echo ""
echo "What Boris provides:"
echo "  • Code quality gates (review, simplify, validate)"
echo "  • Architecture validation"
echo "  • Build and test verification"
echo ""

# Check if Node.js/npm is available
if ! command -v npx &> /dev/null; then
    echo "❌ ERROR: npx not found"
    echo ""
    echo "GSD requires Node.js/npm to install."
    echo "Please install Node.js first:"
    echo "  • macOS: brew install node"
    echo "  • Linux: apt install nodejs npm"
    echo "  • Windows: https://nodejs.org"
    echo ""
    exit 1
fi

echo "✅ Node.js detected: $(node --version)"
echo ""

# Prompt for installation
read -p "Install GSD globally (recommended)? [y/N] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📦 Installing Get-Shit-Done globally..."
    echo "   (This may take 1-2 minutes)"
    echo ""

    # Install GSD globally
    if npx get-shit-done-cc --global; then
        echo ""
        echo "✅ GSD installed successfully!"
        echo ""
        echo "Installation location: ~/.claude/commands/gsd/"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Available GSD Commands:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  /gsd:new-project       Start new multi-week project"
        echo "  /gsd:discuss-phase N   Capture architectural decisions"
        echo "  /gsd:plan-phase N      Break phase into atomic tasks"
        echo "  /gsd:execute-phase N   Execute tasks in parallel"
        echo "  /gsd:verify-work N     Verify phase with UAT testing"
        echo "  /gsd:complete-milestone Archive milestone and tag release"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Boris Quality Gates (manual invocation):"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  After DISCUSS:  'Use code-architect to validate'"
        echo "  After EXECUTE:  'Run code-reviewer and code-simplifier'"
        echo "  During VERIFY:  'Use verify-app to run tests'"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "📚 Documentation:"
        echo ""
        echo "  • Complete guide:  docs/GSD_INTEGRATION.md"
        echo "  • Integration map: .claude/workflows/boris-gsd-integration.md"
        echo "  • Example project: examples/gsd-ecommerce-example.md"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "🚀 Quick Start:"
        echo ""
        echo "  1. Open Claude Code in this directory:"
        echo "     $ claude"
        echo ""
        echo "  2. Start your first GSD project:"
        echo "     /gsd:new-project"
        echo ""
        echo "  3. Follow the guide:"
        echo "     cat docs/GSD_INTEGRATION.md"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "✨ Setup complete! Happy building!"
        echo ""
    else
        echo ""
        echo "❌ Installation failed"
        echo ""
        echo "Troubleshooting:"
        echo "  1. Check internet connection"
        echo "  2. Try updating npm: npm install -g npm@latest"
        echo "  3. Manual install: npx get-shit-done-cc --global"
        echo ""
        exit 1
    fi
else
    echo ""
    echo "⏭️  Installation skipped"
    echo ""
    echo "You can install GSD later by running:"
    echo "  $ npx get-shit-done-cc --global"
    echo ""
    echo "Or run this script again:"
    echo "  $ ./.claude/setup-gsd.sh"
    echo ""
fi
