# Claude Agents Framework - Bash Aliases

alias carch='cat ~/.claude/agents/architect.md'
alias cdev='cat ~/.claude/agents/developer.md'
alias cqa='cat ~/.claude/agents/qa.md'
alias csec='cat ~/.claude/agents/security.md'
alias cdocs='cat ~/.claude/agents/docs.md'

# Advanced usage
alias carchrun='f(){ cat ~/.claude/agents/architect.md && echo "\n=== TASK ===\n$@"; }; f'
alias cdevrun='f(){ cat ~/.claude/agents/developer.md && echo "\n=== TASK ===\n$@"; }; f'
