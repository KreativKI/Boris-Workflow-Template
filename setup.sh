#!/bin/bash
#
# Boris Workflow Template - Project Setup
# Run this ONCE after copying the template folder to initialize your project.
#

set -e

echo "🚀 Boris Workflow Template Setup"
echo "================================="
echo ""

# Check if we're in a copied template (has .git pointing to template repo)
if [ -d ".git" ]; then
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$REMOTE_URL" == *"Boris-Workflow-Template"* ]] || [[ "$REMOTE_URL" == *"boris_claude_code_template"* ]]; then
        echo "⚠️  Detected template's .git folder - removing it..."
        rm -rf .git
        echo "✅ Removed old .git folder"
    else
        echo "⚠️  This folder already has a different git repository."
        echo "   Remote: $REMOTE_URL"
        read -p "   Remove and reinitialize? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf .git
            echo "✅ Removed old .git folder"
        else
            echo "❌ Aborted. Keeping existing .git"
            exit 1
        fi
    fi
fi

# Initialize new git repository
echo ""
echo "📁 Initializing new git repository..."
git init
echo "✅ Git initialized"

# Ask for remote repository URL (optional)
echo ""
read -p "🔗 Enter your GitHub repo URL (or press Enter to skip): " REPO_URL

if [ -n "$REPO_URL" ]; then
    git remote add origin "$REPO_URL"
    echo "✅ Remote 'origin' set to: $REPO_URL"
fi

# Initial commit
echo ""
echo "📝 Creating initial commit..."
git add .
git commit -m "Initial commit: Project setup from Boris Workflow Template

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
echo "✅ Initial commit created"

# Push if remote was set
if [ -n "$REPO_URL" ]; then
    echo ""
    read -p "🚀 Push to remote? (Y/n): " push_confirm
    if [[ ! "$push_confirm" =~ ^[Nn]$ ]]; then
        git push -u origin main 2>/dev/null || git push -u origin master
        echo "✅ Pushed to remote"
    fi
fi

echo ""
echo "================================="
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md with your project specifics"
echo "  2. Run 'claude' to start coding with Boris workflow"
echo ""

# Self-destruct option
read -p "🗑️  Delete this setup script? (Y/n): " delete_confirm
if [[ ! "$delete_confirm" =~ ^[Nn]$ ]]; then
    rm -- "$0"
    echo "✅ Setup script removed"
fi
