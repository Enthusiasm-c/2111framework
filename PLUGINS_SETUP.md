# 🔌 Claude Code Plugins Setup

Интеграция официальных плагинов Anthropic с 2111framework.

## 🚀 Quick Setup

Выполни в Claude Code терминале:

```bash
# 1. Добавить официальный маркетплейс Anthropic
/plugin marketplace add anthropics/claude-code

# 2. Установить ключевые плагины
/plugin install frontend-design
/plugin install skill-creator

# 3. Проверить установку
/plugin
```

## 📦 Рекомендуемые плагины

### Обязательные

| Плагин | Что делает | Почему нужен |
|--------|-----------|--------------|
| `frontend-design` | Distinctive UI вместо generic | Твои продукты user-facing |
| `skill-creator` | Создание своих skills | Для кастомизации фреймворка |

### Опциональные

| Плагин | Что делает |
|--------|-----------|
| `pr-review` | Автоматический code review |
| `feature-dev` | Структурированная разработка фич |

## 🎨 frontend-design Plugin

### Что решает

**Проблема:** Claude без инструкций делает "AI slop":
- Inter/Roboto шрифты
- Фиолетовые градиенты
- Скучные стандартные layouts

**Решение:** Skill автоматически активируется и заставляет Claude:
1. Выбирать BOLD aesthetic direction
2. Использовать уникальные шрифты
3. Создавать memorable дизайн
4. Писать production-ready код

### Как использовать

**Автоматически** — просто проси создать UI:

```
Создай dashboard для ресторанной аналитики.
Dark theme, mobile-first.
```

Claude сам применит frontend-design skill.

**Явно** — если хочешь убедиться:

```
Use the frontend design skill.
Create a settings page for Telegram Mini App.
```

### Примеры промптов

```
# Для Ave AI
Create an analytics dashboard for restaurant sales.
Show daily revenue chart, top products, inventory alerts.
Dark theme, modern aesthetic, mobile-first.

# Для NotaApp  
Design an invoice review screen for Telegram Mini App.
Show photo preview, extracted data form, submit button.
Clean, professional, touch-friendly.

# Для FIGHTSTARS
Build a player profile card component.
Show avatar, stats, achievements, ranking.
Gaming aesthetic, bold colors, micro-animations.
```

## 🏗️ Интеграция с 2111framework

### Структура после установки

```
Claude Code
├── /plugins (встроенные)
│   ├── frontend-design    ← UI quality
│   └── skill-creator      ← создание skills
│
└── ~/.claude/ (твой фреймворк)
    ├── agents/            ← workflow агенты
    ├── skills/            ← технические справочники
    └── projects/          ← контексты проектов
```

### Когда что использовать

| Задача | Что использует Claude |
|--------|----------------------|
| Создать UI компонент | `frontend-design` plugin (auto) |
| Интеграция с Syrve | `~/.claude/skills/integrations/syrve-api.md` |
| Планирование фичи | `~/.claude/agents/architect.md` |
| Контекст проекта | `~/.claude/projects/ave-ai.md` |

### Пример полного workflow

```bash
# 1. Загрузить контекст проекта
"Прочитай ~/.claude/projects/ave-ai.md"

# 2. Спланировать фичу (architect agent)
"Прочитай ~/.claude/agents/architect.md
 Спланируй добавление графика продаж по дням"

# 3. Реализовать UI (frontend-design plugin активируется автоматически)
"Реализуй Phase 1: создай компонент SalesChart"

# 4. Интеграция с данными (skill)
"Прочитай ~/.claude/skills/integrations/syrve-api.md
 Подключи реальные данные из Syrve"
```

## ⚙️ Настройка Claude Code /agents

Добавь в Claude Code базовый контекст:

```bash
# В Claude Code
/agents
```

Создай агента с твоим стеком:

```markdown
# Denis Development Agent

## Stack
- Next.js 14+ App Router
- TypeScript strict
- NeonDB + Drizzle
- shadcn/ui + Tailwind
- Vercel deployment
- Telegram Mini Apps

## Style
- Step-by-step with checkpoints
- Brief explanations
- Mobile-first (80% users)
- Code > talk

## Auto-load skills from
~/.claude/skills/

## Projects
- Ave AI: restaurant analytics
- NotaApp: invoice OCR
- FIGHTSTARS: gaming app
```

## 🔄 Синхронизация

### Plugins (Anthropic)
- Обновляются автоматически
- Managed by Anthropic
- Не редактируемые

### Framework (твой)
- Полный контроль
- Редактируй как хочешь
- Храни в GitHub

## 📋 Чеклист установки

- [ ] `/plugin marketplace add anthropics/claude-code`
- [ ] `/plugin install frontend-design`
- [ ] `/plugin install skill-creator`
- [ ] Настроить `/agents` с базовым контекстом
- [ ] Клонировать 2111framework: `git clone https://github.com/Enthusiasm-c/2111framework.git`
- [ ] Запустить `./install.sh`
- [ ] Создать `~/.claude/projects/` с контекстами проектов

## 🐛 Troubleshooting

### Plugin не активируется
```bash
# Проверить установку
/plugin

# Переустановить
/plugin uninstall frontend-design
/plugin install frontend-design
```

### Skill не применяется к UI
Добавь явно в промпт:
```
Use the frontend design skill.
[твой запрос]
```

### Конфликт с MD skills
Plugins и MD skills работают вместе. Plugins для общего (UI quality), MD skills для специфичного (Syrve API).
