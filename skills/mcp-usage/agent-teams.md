---
name: agent-teams
description: Parallel agent coordination in Claude Code. Use when tasks benefit from multiple agents working simultaneously -- code review, feature development, or research from multiple angles.
model: opus
context: fork
---

# Agent Teams - Parallel Agent Coordination

Run multiple Claude agents in parallel within a single session.

## Activation

Agent Teams is an experimental feature. Enable it:

```bash
# Via environment variable
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true

# Or via settings.json
claude config set experimental.agentTeams true
```

---

## Architecture

```
Lead Agent (you interact with this)
├── Teammate 1 (autonomous worker)
├── Teammate 2 (autonomous worker)
└── Teammate 3 (autonomous worker)

Shared: Task List + Mailbox (message passing)
```

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Lead Agent** | Main agent that coordinates work, assigns tasks |
| **Teammates** | Spawned agents working in parallel on sub-tasks |
| **Task List** | Shared todo list visible to all agents |
| **Mailbox** | Message passing between lead and teammates |

---

## When to Use Agent Teams

### Use Agent Teams

- Code review from multiple angles (security + performance + correctness)
- Feature development with parallel concerns (API + UI + tests)
- Research across multiple codebases or documentation sources
- Consilium-style parallel analysis
- Large refactoring across many files

### Use SubAgents (Task tool) Instead

- Simple delegation of a single focused task
- Protecting context window from large outputs
- Sequential dependency chains

### Use Solo Agent

- Simple bug fixes
- Single-file edits
- Quick lookups

---

## Patterns

### Pattern 1: Parallel Code Review

```
Lead: "Review src/auth/ for security, performance, and correctness"

→ Teammate 1: Security audit (OWASP, auth bypass, injection)
→ Teammate 2: Performance review (N+1, memory, async)
→ Teammate 3: Correctness review (edge cases, types, logic)

Lead: Synthesizes all findings into unified report
```

### Pattern 2: Feature Development

```
Lead: "Implement user notifications feature"

→ Teammate 1: API routes and database schema
→ Teammate 2: React components and UI
→ Teammate 3: Test suite

Lead: Integrates all work, resolves conflicts
```

### Pattern 3: Consilium Parallel Mode

```
/consilium [product brief]

Lead: Research Agent scans codebase
→ Teammate 1: Growth + Sales analysis
→ Teammate 2: Product + Tech analysis
→ Teammate 3: Finance + Market analysis

Lead: Orchestrator synthesizes unified plan
```

---

## Display Modes

### In-Process (Default)

All agents run in the same terminal. Output interleaved with labels.

### Split Panes (Advanced)

```bash
# tmux: split into panes per agent
tmux split-window -h  # horizontal split
tmux split-window -v  # vertical split

# iTerm2: use tabs or split panes
```

---

## Cost Control

Agent Teams multiply token usage. Be aware:

| Agents | Approximate Cost Multiplier |
|--------|----------------------------|
| Lead + 1 | ~2x |
| Lead + 2 | ~3x |
| Lead + 3 | ~4x |

### Tips

- Use `effortLevel: medium` for teammates doing routine work
- Set clear, scoped tasks to avoid open-ended exploration
- Monitor with `claude --usage` after sessions
- Start with 1-2 teammates, scale up if needed

---

## Limitations

- Experimental feature, may change in future releases
- Teammates share the same file system -- watch for write conflicts
- No built-in conflict resolution for simultaneous edits
- Lead agent context grows with coordination overhead
- Requires more API tokens than solo mode

---

## Integration with 2111framework

```bash
# Review with Agent Teams
/review src/features/auth/    # Lead coordinates security + correctness + perf teammates

# Ralph + Agent Teams
/ralph-loop "Implement CRUD" --max-iterations 25
# Each iteration can spawn teammates for parallel sub-tasks

# Consilium with Agent Teams
/consilium [brief]
# 6 analyst agents run as teammates in parallel
```

---

## Related Skills

- `ralph-wiggum.md` - Autonomous loops (can use teammates)
- `consilium.md` - Product analysis (natural fit for parallel agents)
- `review.md` - Code review (parallel review angles)
