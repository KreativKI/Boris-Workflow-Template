# Contributing to Boris Workflow Template

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use a clear, descriptive title
3. Include steps to reproduce the issue
4. Describe expected vs actual behavior

### Suggesting Enhancements

1. Open an issue with the `enhancement` label
2. Describe the use case and benefits
3. Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test your changes
5. Commit with clear messages following [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `refactor:` for code refactoring
6. Push to your fork
7. Open a Pull Request

## Development Guidelines

### Agent Modifications

When modifying agents in `.claude/agents/`:

- Keep the YAML frontmatter format
- Document the agent's purpose clearly
- Specify appropriate tools and model
- Test the agent before submitting

### Command Modifications

When modifying commands in `.claude/commands/`:

- Follow the existing markdown format
- Include clear instructions
- Test the command workflow

### CLAUDE.md Updates

When updating `CLAUDE.md`:

- Keep sections organized
- Add new learned rules to the table
- Maintain backward compatibility

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the issue, not the person

## Questions?

Open an issue with the `question` label.
