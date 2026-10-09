# 🚀 Загрузка модели в Ollama (Windows)

## Этап 1: Установить Ollama

### Шаг 1.1: Скачай Ollama
- Перейди на https://ollama.ai
- Нажми "Download for Windows"
- Установи как обычное приложение

### Шаг 1.2: Проверь установку
```bash
ollama --version
# Должно вывести версию, например: ollama version 0.1.18
```

---

## Этап 2: Конвертировать модель в GGUF

### Шаг 2.1: Установи зависимости
```bash
pip install llama-cpp-python
```

### Шаг 2.2: Запусти конвертер
```bash
cd H:\qte56\arch_new
python convert_to_gguf.py
```

**Что происходит:**
- Конвертирует `qwen-d-qte56-7b-merged` в GGUF (15-30 минут)
- Квантизирует до q4_k_m (4-8 ГБ вместо 14.5 ГБ)
- Сохраняет: `qwen-d-qte56-7b-merged_q4_k_m.gguf`

---

## Этап 3: Загрузить модель в Ollama

### Способ A: Через веб-интерфейс (ЛЕГЧЕ)

1. **Запусти Ollama:**
   - Найди Ollama в меню Пуск
   - Запусти приложение
   - Откроется веб-интерфейс на `http://localhost:3000`

2. **Загрузи модель:**
   - В интерфейсе → "Import"
   - Выбери файл: `qwen-d-qte56-7b-merged_q4_k_m.gguf`
   - Дай имя: `qte56`
   - Нажми "Import"

---

### Способ B: Через командную строку (ПРОДВИНУТЫЙ)

**Шаг 3.1: Создай Modelfile**

Создай файл `C:\Users\gena\models\Modelfile` (БЕЗ расширения):

```modelfile
FROM c:\Users\gena\models\qwen-d-qte56-7b-merged_q4_k_m.gguf

# Параметры
PARAMETER temperature 0.7
PARAMETER top_p 0.95
PARAMETER top_k 40

# Системное сообщение
SYSTEM """You are QTE56 expert. Answer questions about QTE56 Qt bindings for D language."""
```

**Шаг 3.2: Запусти в PowerShell**

```powershell
cd C:\Users\gena\models
ollama create qte56 -f Modelfile
```

**Шаг 3.3: Проверь что загружена**

```bash
ollama list
# Должна быть в списке: qte56
```

---

## Этап 4: Используй модель

### Способ 1: Веб-интерфейс (САМЫЙ ПРОСТО)

```bash
ollama serve
```

Открой браузер: http://localhost:3000

Выбери модель `qte56` и пиши вопросы!

---

### Способ 2: Командная строка

```bash
ollama run qte56
# Теперь пиши вопросы:
>>> Как создать QWidget с кнопкой?
Loading model...
(модель ответит)

>>> /bye  # для выхода
```

---

### Способ 3: API для приложений

```bash
ollama serve
```

В другом терминале:

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qte56",
  "prompt": "Как создать QWidget?",
  "stream": false
}'
```

---

## Параметры в Modelfile

| Параметр | Значение | Что это |
|----------|----------|--------|
| temperature | 0.7 | Творчество (0=точно, 1=случайно) |
| top_p | 0.95 | Разнообразие ответов |
| top_k | 40 | Сколько вариантов рассматривать |

---

## Если что-то не работает

### Ошибка: "Не нашёл GGUF файл"
```
Проверь пути в Modelfile:
  ❌ FROM ./qwen-d-qte56.gguf     (относительный путь)
  ✅ FROM C:\Users\gena\models\qwen-d-qte56.gguf  (полный путь)
```

### Ошибка: "Ollama не запускается"
```bash
# Проверь что установлена:
ollama --version

# Если не установлена, установи с https://ollama.ai
```

### Модель работает медленно
```
Это нормально на RTX 3060!
- q4_k_m квантизация: 5-10 токенов/сек
- Для ускорения: используй q3_k_s (меньше качество, быстрее)
```

---

## Итого

```
✅ Ollama установлена
✅ Модель конвертирована в GGUF
✅ Модель загружена в Ollama
✅ Модель работает в веб-интерфейсе

Теперь у тебя есть свой личный ChatGPT со знаниями QTE56! 🎉
```

---

**Дата:** 2026-04-25  
**Версия:** 1.0
