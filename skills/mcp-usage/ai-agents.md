---
name: ai-agents
description: Natural language commands for external AI agents (Gemini, Codex)
category: mcp-usage
trigger: запусти агента, ask gemini, ask codex, второе мнение
updated: 2026-01-09
model: haiku
forked_context: false
hooks:
  pre_invoke:
    - command: "echo '🤖 AI Agents: Routing to external agent...'"
---

# AI Agents - Natural Language Commands

## Как использовать

Просто скажи Claude на естественном языке:

```
"Запусти агента Gemini review для [описание проблемы] в [файл/страница]"
"Попроси Codex найти баг в [описание]"
"Нужно второе мнение по [проблема]"
```

---

## Команды и их маппинг

### Gemini Agent (UI/Frontend)

| Фраза пользователя | Claude выполняет |
|-------------------|------------------|
| "Запусти агента Gemini review для broken layout в странице аналитики" | `find src -name "*analytics*" -o -name "*Analytics*" \| head -5` затем `cat <files> \| gemini -m gemini-3-pro-preview -p "Find root cause of broken UI layout:"` |
| "Попроси Gemini проверить UI в Dashboard" | `cat src/**/Dashboard*.tsx \| gemini -m gemini-3-pro-preview -p "Review UI for bugs:"` |
| "Gemini, найди CSS проблему" | `cat <file> \| gemini -m gemini-3-pro-preview -p "Find CSS/styling issue:"` |

### Codex Agent (Logic/TypeScript)

| Фраза пользователя | Claude выполняет |
|-------------------|------------------|
| "Запусти агента Codex для race condition в auth" | `find src -name "*auth*" \| head -5` затем `cat <files> \| codex exec -m gpt-5.1-codex-max -s read-only "Find race condition:"` |
| "Попроси Codex проверить типы" | `cat <file> \| codex exec -m gpt-5.1-codex-max -s read-only "Find TypeScript type errors:"` |
| "Codex, security review" | `cat <file> \| codex exec -m gpt-5.1-codex-max -s read-only "Security audit: OWASP Top 10:"` |

### Второе мнение (оба агента)

| Фраза пользователя | Claude выполняет |
|-------------------|------------------|
| "Нужно второе мнение по этому багу" | Запускает и Codex и Gemini, сравнивает результаты |
| "Не могу найти причину, спроси других" | Сначала Codex (логика), потом Gemini (UI) |

---

## Workflow для Claude

Когда пользователь говорит "запусти агента [name] для [problem] в [location]":

### Step 1: Найти файлы
```bash
# По названию страницы/компонента
find src -iname "*analytics*" -type f \( -name "*.tsx" -o -name "*.ts" \)

# Или по grep если известен текст
grep -rl "Analytics" src --include="*.tsx" | head -5
```

### Step 2: Выбрать агента

| Проблема содержит | Агент |
|-------------------|-------|
| UI, layout, CSS, стили, визуальный | **Gemini** |
| баг, race condition, async, типы, логика | **Codex** |
| security, auth, injection | **Codex** |
| не знаю | **Оба** |

### Step 3: Запустить анализ
```bash
# Gemini для UI
cat <files> | gemini -m gemini-3-pro-preview -p "<problem description>:"

# Codex для логики
cat <files> | codex exec -m gpt-5.1-codex-max -c model_reasoning_effort=\"high\" -s read-only "<problem description>:"
```

### Step 4: Показать результат и предложить fix

---

## Примеры полных диалогов

### Пример 1: UI проблема
```
User: Запусти агента Gemini review чтобы найти корневую причину
      broken ui layout в странице аналитика в админке

Claude: Ищу файлы аналитики...
        [находит: src/app/admin/analytics/page.tsx]

        Запускаю Gemini анализ...
        [выполняет: cat src/app/admin/analytics/page.tsx | gemini ...]

        Gemini нашёл:
        - Line 45: flex-direction конфликт с parent container
        - Line 78: missing overflow-hidden causing layout shift

        Исправляю...
```

### Пример 2: Логическая проблема
```
User: Попроси Codex найти почему форма отправляется дважды

Claude: Ищу файлы с формой...
        [находит: src/components/ContactForm.tsx]

        Запускаю Codex анализ...
        [выполняет: cat ... | codex exec ...]

        Codex нашёл:
        - Line 23: onClick и onSubmit оба вызывают handleSubmit
        - Line 31: missing event.preventDefault()

        Исправляю...
```

### Пример 3: Нужно второе мнение
```
User: Не могу понять почему график не рендерится, нужно второе мнение

Claude: Запускаю оба агента...

        Codex (логика): Data fetching race condition at line 45
        Gemini (UI): Chart container has height: 0 at line 89

        Обе проблемы валидны. Начну с CSS fix, затем race condition.
```

---

## Environment Variables

Убедись что в `~/.zshrc`:
```bash
export GEMINI_API_KEY="your-gemini-api-key"
export OPENAI_API_KEY="your-openai-api-key"
```

Получить ключи:
- Gemini: https://aistudio.google.com/apikey
- OpenAI: https://platform.openai.com/api-keys

---

## Когда какой агент лучше

```
┌─────────────────────────────────────────────────┐
│  "UI сломан"        → Gemini                    │
│  "Стили поехали"    → Gemini                    │
│  "Layout broken"    → Gemini                    │
│  "Не центрируется"  → Gemini                    │
├─────────────────────────────────────────────────┤
│  "Дважды срабатывает" → Codex                   │
│  "Race condition"     → Codex                   │
│  "TypeScript ошибка"  → Codex                   │
│  "Async проблема"     → Codex                   │
│  "Security issue"     → Codex                   │
├─────────────────────────────────────────────────┤
│  "Не понимаю причину" → Оба                     │
│  "Второе мнение"      → Оба                     │
└─────────────────────────────────────────────────┘
```
