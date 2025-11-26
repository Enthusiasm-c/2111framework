# 🤖 2111framework

Claude Code framework с агентами, skills и интеграцией официальных плагинов Anthropic.

## 🚀 Quick Setup

### Step 1: Установи плагины (в Claude Code терминале)
```bash
/plugin marketplace add anthropics/claude-code
/plugin install frontend-design
```

### Step 2: Установи фреймворк
```bash
git clone https://github.com/Enthusiasm-c/2111framework.git
cd 2111framework
./install.sh
```

### Step 3: Настрой /agents
См. `CLAUDE_CODE_AGENT.md` для рекомендуемого конфига.

## 📦 Что включено

**Official Plugins (Anthropic):**
- `frontend-design` — distinctive UI, никакого generic AI дизайна

**Agents (workflow):**
- Architect, Developer, QA, Security, Docs

**Skills (knowledge bases):**
- Syrve API, NeonDB, Vercel, Telegram
- Next.js, TypeScript, React, shadcn/ui
- Security, Performance, Accessibility
- MCP guides (Context7, Playwright, shadcn)

**Project Contexts:**
- Ave AI, NotaApp, FIGHTSTARS

## 💻 Использование

```bash
# UI работа (frontend-design активируется автоматически)
"Создай dashboard для ресторанной аналитики"

# С контекстом проекта
"Прочитай ~/.claude/projects/ave-ai.md
 Добавь график продаж на dashboard"

# Со специфичным skill
"Прочитай ~/.claude/skills/integrations/syrve-api.md
 Реализуй синхронизацию поставщиков"
```

## 📁 Структура после установки

```
~/.claude/
├── agents/        # Workflow агенты
│   ├── architect.md
│   ├── developer.md
│   ├── qa.md
│   ├── security.md
│   └── docs.md
├── skills/        # Технические справочники
│   ├── integrations/
│   ├── tech-stack/
│   ├── code-quality/
│   └── mcp-usage/
└── projects/      # Контексты проектов
    ├── ave-ai.md
    ├── notaapp.md
    └── fightstars.md
```

## 🔌 Plugins vs Skills

| Аспект | Plugins | Skills (MD файлы) |
|--------|---------|-------------------|
| Источник | Anthropic | Твой фреймворк |
| Загрузка | Автоматически | По запросу |
| Редактирование | Нет | Да |
| Обновления | От Anthropic | Ты контролируешь |
| Пример | frontend-design | syrve-api.md |

**Используй вместе:**
- Plugins для общего (UI quality)
- Skills для специфичного (Syrve API, проекты)

## 📖 Документация

- `PLUGINS_SETUP.md` — Полный гайд по плагинам
- `CLAUDE_CODE_AGENT.md` — Конфигурация /agents
- `skills/` — Все технические справочники
- `projects/` — Контексты проектов

## 🔄 Обновление

```bash
cd 2111framework
git pull
./install.sh
```

---

Built for solo developers working with Claude Code 🚀
