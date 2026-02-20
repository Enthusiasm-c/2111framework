---
alwaysApply: true
description: Git workflow conventions
---

# Git Workflow Rules

- Write conventional commit messages: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- Keep commits focused — one logical change per commit
- Never commit `.env` files, secrets, or API keys
- Create feature branches from `main`: `feat/feature-name`
- Squash-merge feature branches to keep clean history
- Run lint and type checks before committing
- Include ticket/issue number in commit message when applicable
