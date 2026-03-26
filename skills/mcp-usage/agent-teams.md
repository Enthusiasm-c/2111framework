---
name: agent-teams
description: Parallel agent coordination in Claude Code. Use when tasks benefit from multiple agents working simultaneously — code review, feature development, or research from multiple angles.
model: opus
context: fork
---

# Agent Teams — Parallel Agent Coordination

Run multiple Claude agents in parallel within a single session. Agent Teams is now a **stable feature** in Claude Code — no experimental flags needed.

---

## Core Concepts

### Agent Tool

The `Agent` tool spawns specialized subagents. Key parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `subagent_type` | Agent specialization | `"Explore"`, `"dev"`, `"qa"`, `"review"`, `"security"` |
| `isolation` | File system isolation | `"worktree"` — isolated git worktree copy |
| `run_in_background` | Non-blocking execution | `true` — notified on completion |
| `name` | Addressable agent name | `"security-reviewer"` |
| `model` | Model override | `"sonnet"`, `"opus"`, `"haiku"` |
| `mode` | Permission mode | `"plan"`, `"bypassPermissions"`, `"auto"` |

### SendMessage

Continue a running agent's conversation:

```
SendMessage(to: "security-reviewer", message: "Also check for CSRF")
```

Agents resume with full context preserved. Use the agent's `name` or returned `agentId`.

### Worktree Isolation

```
Agent(isolation: "worktree") → temporary git worktree
→ agent works on isolated copy of the repo
→ no file conflicts with other agents
→ auto-cleaned if no changes; branch returned if changes made
```

**When to use:** Any time multiple agents write to the same files. Without worktree isolation, parallel dev agents will overwrite each other.

---

## Architecture

```
Lead Agent (you interact with this)
├── Agent A (isolation: "worktree", run_in_background: true)
├── Agent B (isolation: "worktree", run_in_background: true)
└── Agent C (subagent_type: "Explore")

Communication: SendMessage between named agents
Isolation: Each writing agent gets its own worktree
Background: Lead continues working while agents run
```

---

## When to Use What

| Scenario | Approach |
|----------|----------|
| Code review from 3 angles | 3 parallel agents (security, perf, correctness) |
| Feature dev: API + UI + tests | 3 agents in worktrees, merge after |
| Quick codebase search | Single `Explore` agent |
| Bug investigation | Single focused agent |
| Research across docs | 2-3 `Explore` agents in background |
| Simple file edit | Direct edit, no agents |

---

## Patterns

### Pattern 1: Parallel Code Review

```
Lead spawns 3 agents in parallel (single message, 3 Agent calls):

Agent(
  name: "sec-review",
  subagent_type: "security",
  prompt: "Security audit of src/auth/",
  run_in_background: true
)

Agent(
  name: "perf-review",
  subagent_type: "review",
  prompt: "Performance review of src/auth/ — focus on async patterns, N+1, memory",
  run_in_background: true
)

Agent(
  name: "correctness",
  subagent_type: "qa",
  prompt: "Review src/auth/ for edge cases, type safety, logic errors",
  run_in_background: true
)

Lead: Waits for notifications, synthesizes findings
```

### Pattern 2: Parallel Feature Development

```
Lead: Architect designs the plan

Agent(
  name: "api-dev",
  subagent_type: "dev",
  isolation: "worktree",
  prompt: "Implement API routes per plan: ...",
  run_in_background: true
)

Agent(
  name: "ui-dev",
  subagent_type: "dev",
  isolation: "worktree",
  prompt: "Implement React components per plan: ...",
  run_in_background: true
)

Agent(
  name: "test-dev",
  subagent_type: "dev",
  isolation: "worktree",
  prompt: "Write test suite per plan: ...",
  run_in_background: true
)

Lead: Merges worktree branches when all complete
```

### Pattern 3: Research Fan-out

```
Lead needs to understand 3 unfamiliar codebases:

Agent(subagent_type: "Explore", prompt: "How does auth work in src/lib/auth/?", run_in_background: true)
Agent(subagent_type: "Explore", prompt: "How does the API layer work in src/app/api/?", run_in_background: true)
Agent(subagent_type: "Explore", prompt: "What's the database schema in src/db/?", run_in_background: true)

Lead: Continues planning while research runs
```

### Pattern 4: Consilium Parallel Analysis

```
/consilium [product brief]

Lead (Research Agent): Scans codebase first

→ Agent 1: Growth + Sales analysis
→ Agent 2: Product + Tech analysis
→ Agent 3: Finance + Market analysis

Lead (Orchestrator): Synthesizes unified plan
```

---

## Cost Control

Parallel agents multiply token usage:

| Setup | Cost Multiplier |
|-------|----------------|
| Lead + 1 agent | ~2x |
| Lead + 2 agents | ~3x |
| Lead + 3 agents | ~4x |

### Tips

- Use `model: "sonnet"` for routine agents (exploration, simple reviews)
- Use `model: "opus"` only for security and complex analysis
- Set clear, scoped prompts — avoid open-ended exploration
- Use `run_in_background: true` to avoid idle waiting
- Monitor usage with `claude --usage`
- Start with 1-2 agents, scale up if needed

---

## Worktree Merge Workflow

When parallel dev agents work in worktrees:

1. Each agent creates changes on an isolated branch
2. Agent result includes worktree path and branch name
3. Lead merges branches sequentially:

```bash
git merge <branch-from-agent-1> --no-ff
git merge <branch-from-agent-2> --no-ff
# Resolve conflicts if any
```

4. Worktrees with no changes are auto-cleaned

---

## Limitations

- Worktree agents can't see each other's changes until merged
- Lead agent context grows with each agent's report
- Background agents can't ask clarifying questions
- File conflicts possible without worktree isolation
- Token usage scales linearly with agent count

---

## Integration with 2111framework

```bash
# Review with parallel agents
/review src/features/auth/    # Lead coordinates 3 review angles

# Ralph Wiggum + parallel review after
/ralph-loop "Implement CRUD" --max-iterations 25
# Then spawn parallel review agents on the generated code

# Consilium with parallel analysts
/consilium [brief]
# 6 analyst agents run in parallel
```

---

## Related Skills

- `ralph-wiggum.md` — Autonomous loops (review results with parallel agents)
- `consilium.md` — Product analysis (natural fit for parallel agents)
- `review.md` — Code review (parallel review angles)
