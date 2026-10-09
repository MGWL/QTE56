# 🔍 Анализ и Исправления train_qte56.py

## Итоговая Оценка

**Исходный скрипт**: ⚠️ **75% корректен, но имеет критические проблемы**

| Аспект | Статус | Комментарий |
|--------|--------|-----------|
| Структура | ✅ Good | Логичная организация |
| Параметры | ⚠️ Warning | Может быть проблема с оптимизатором |
| Датасет | ❌ Critical | Нет проверки формата |
| Ошибки | ❌ Critical | Нет обработки исключений |
| VRAM | ⚠️ Warning | Может быть недостаточно |

---

## 🔴 КРИТИЧЕСКИЕ ПРОБЛЕМЫ

### 1. **Отсутствие Проверки Датасета**

**Исходный код:**
```python
dataset = load_dataset("json", data_files=DATASET_PATH, split="train")
print(f"Примеров в датасете: {len(dataset)}")
```

**Проблема:**
- ❌ Нет проверки, существует ли файл
- ❌ Нет валидации формата JSON
- ❌ Нет проверки, есть ли поле "messages"
- **Результат:** Скрипт упадёт с криптичной ошибкой

**Исправление:**
```python
# ВАРИАНТ 1: Проверка файла
if not Path(DATASET_PATH).exists():
    print(f"[ERROR] Датасет не найден: {DATASET_PATH}")
    sys.exit(1)

# ВАРИАНТ 2: Валидация формата
with open(DATASET_PATH, 'r', encoding='utf-8') as f:
    first_line = f.readline()
    first_example = json.loads(first_line)

if "messages" not in first_example:
    print("[ERROR] Датасет должен иметь 'messages' поле!")
    sys.exit(1)
```

---

### 2. **apply_chat_template Может Не Сработать**

**Исходный код:**
```python
def format_chat(example):
    text = tokenizer.apply_chat_template(
        example["messages"],
        tokenize=False,
        add_generation_prompt=False,
    )
    return {"text": text}
```

**Проблема:**
- ❌ `apply_chat_template()` может не существовать в tokenizer
- ❌ Нет обработки ошибок
- ❌ Если chat template отсутствует → скрипт упадёт
- **Результат:** `AttributeError: 'GPT2TokenizerFast' object has no attribute 'apply_chat_template'`

**Правильное исправление:**
```python
def format_chat(example):
    messages = example.get("messages", [])
    
    # Способ 1: Попробуй apply_chat_template (если есть)
    try:
        text = tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=False,
        )
        return {"text": text}
    except (AttributeError, TypeError):
        # Способ 2: Fallback — простое объединение
        text = ""
        for msg in messages:
            role = msg.get("role", "")
            content = msg.get("content", "")
            if role == "user":
                text += f"User: {content}\n"
            elif role == "assistant":
                text += f"Assistant: {content}\n"
        return {"text": text}
```

---

### 3. **Конфликт Оптимизаторов**

**Исходный код:**
```python
# training_args = TrainingArguments(
#     ...
#     optim="adamw_8bit",
# )

training_args = TrainingArguments(
    ...
    optim="adamw_bnb_8bit",
    # optim="cpu_adamw"
)
```

**Проблема:**
- ❌ Закомментирована настройка, но есть конфликтующие опции
- ❌ `cpu_adamw` очень медленный (не рекомендуется)
- ❌ `adamw_bnb_8bit` требует bitsandbytes (может быть не установлен)
- **Результат:** Непредсказуемое поведение или ошибка

**Правильное решение:**
```python
# Выбери ОД0Н оптимизатор:

# ДЛЯ RTX 3060 12GB: adamw_bnb_8bit (рекомендуется)
optim="adamw_bnb_8bit",

# ДЛЯ A100 80GB: обычный adamw
optim="adamw_torch",

# Проверка перед использованием:
try:
    import bitsandbytes
except ImportError:
    print("[WARNING] bitsandbytes не установлена!")
    print("Установи: pip install bitsandbytes")
```

---

### 4. **Отсутствие Обработки Ошибок**

**Исходный код:**
```python
model, tokenizer = FastLanguageModel.from_pretrained(...)
dataset = load_dataset(...)
trainer.train()
```

**Проблема:**
- ❌ Нет try-except блоков
- ❌ Если что-то пойдёт неправильно → скрипт упадёт с криптичной ошибкой
- ❌ Потеряешь время на отладку
- **Результат:** CUDA OOM, FileNotFoundError и т.д. без ясной информации

**Исправление:**
```python
try:
    model, tokenizer = FastLanguageModel.from_pretrained(...)
    print("[OK] Модель загружена")
except Exception as e:
    print(f"[ERROR] Ошибка при загрузке модели: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

try:
    trainer.train()
    print("[OK] Тренировка завершена")
except torch.cuda.OutOfMemoryError:
    print("[ERROR] CUDA out of memory!")
    print("Уменьши: batch_size или max_seq_length")
    sys.exit(1)
except Exception as e:
    print(f"[ERROR] Ошибка при тренировке: {e}")
    sys.exit(1)
```

---

### 5. **Отсутствие Проверки CUDA и GPU**

**Исходный код:**
```python
if torch.cuda.is_available():
    free_mem = torch.cuda.mem_get_info()[0] / 1024**3
    total_mem = torch.cuda.mem_get_info()[1] / 1024**3
    print(f"\nVRAM: {free_mem:.1f}GB свободно / {total_mem:.1f}GB всего")
```

**Проблема:**
- ❌ Если CUDA **не** доступна → скрипт молча продолжит (и упадёт позже)
- ❌ Не проверяется что GPU достаточно мощная
- ❌ VRAM проверка идёт только перед стартом (может измениться)

**Исправление:**
```python
if not torch.cuda.is_available():
    print("[ERROR] CUDA не доступна! Нужна NVIDIA GPU")
    sys.exit(1)

gpu_name = torch.cuda.get_device_name(0)
print(f"[OK] GPU: {gpu_name}")

free_gb, total_gb = torch.cuda.mem_get_info()[0] / (1024**3), torch.cuda.mem_get_info()[1] / (1024**3)
print(f"[OK] VRAM: {free_gb:.1f}GB / {total_gb:.1f}GB")

if total_gb < 10:
    print("[WARNING] Меньше 10GB VRAM - может быть проблемно!")
    print("Уменьши batch_size или max_seq_length")
```

---

## ⚠️ ПРЕДУПРЕЖДЕНИЯ

### 1. **Параметр `save_merged_16bit`**

**Исходный код:**
```python
model.save_pretrained_merged(
    OUTPUT_MERGED,
    tokenizer,
    save_method="merged_16bit",
)
```

**Внимание:**
- ✅ Правильный способ для unsloth
- ⚠️ Но может вывести ошибку если unsloth версия старая
- ✅ Проверь что установлена последняя версия: `pip install -U unsloth`

---

### 2. **Параметр `packing=True`**

**Исходный код:**
```python
trainer = SFTTrainer(
    ...
    packing=True,
)
```

**Внимание:**
- ✅ Хороший параметр для скорости
- ⚠️ Может привести к проблемам если примеры очень разных размеров
- ✅ Для вашего датасета должно работать

---

### 3. **max_seq_length = 2048**

**Исходный код:**
```python
MAX_SEQ_LENGTH = 2048
```

**Внимание:**
- ✅ Хорошо для RTX 3060 12GB
- ⚠️ Если CUDA OOM → уменьши до 1024
- ⚠️ Если примеры длинные → нужна 24GB+ GPU

**Если CUDA OOM:**
```python
# Вариант 1: Уменьши контекст
MAX_SEQ_LENGTH = 1024

# Вариант 2: Уменьши батч
BATCH_SIZE = 1
GRAD_ACCUM = 4

# Вариант 3: Отключи gradient checkpointing (медленнее, но мощнее)
gradient_checkpointing = False
```

---

## ✅ ЧТО ИСПРАВЛЕНО

### В `train_qte56_fixed.py`:

1. **✅ Проверка зависимостей** — проверяет все импорты в начале
2. **✅ Проверка GPU** — валидирует что CUDA доступна
3. **✅ Проверка файлов** — проверяет что модель и датасет существуют
4. **✅ Валидация датасета** — читает первую строку и проверяет формат
5. **✅ Обработка ошибок** — try-except для всех критических операций
6. **✅ Fallback для apply_chat_template** — если tokenizer не поддерживает
7. **✅ Выбор оптимизатора** — четкий выбор adamw_bnb_8bit
8. **✅ Логирование** — подробные сообщения на каждом шаге
9. **✅ Проверка VRAM** — валидирует достаточно ли памяти
10. **✅ Рекомендации** — советует что делать если ошибка

---

## 📋 Чек-лист Перед Запуском

- [ ] Установлены все зависимости:
  ```bash
  pip install torch transformers unsloth datasets trl bitsandbytes
  ```

- [ ] Модель загружена:
  ```
  c:\Users\gena\models\Qwen2.5-Coder-7B-Instruct\
  ```

- [ ] Датасет на месте:
  ```
  c:\gpt\qte56\arch_new\dataset_generated.jsonl
  ```

- [ ] NVIDIA GPU доступна:
  ```bash
  nvidia-smi
  ```

- [ ] Свободно ≥ 10GB VRAM:
  ```bash
  nvidia-smi | grep MiB
  ```

- [ ] Запусти исправленный скрипт:
  ```bash
  python train_qte56_fixed.py
  ```

---

## 🚀 Рекомендация

**Используй `train_qte56_fixed.py` вместо оригинала** — он имеет:
- ✅ Полную валидацию входных данных
- ✅ Обработку всех типичных ошибок
- ✅ Подробное логирование
- ✅ Рекомендации при проблемах
- ✅ Проверку зависимостей

---

## Резюме Исправлений

| Проблема | Статус | Исправление |
|----------|--------|-----------|
| Нет проверки датасета | ❌ → ✅ | Добавлена валидация |
| apply_chat_template ошибка | ❌ → ✅ | Добавлен fallback |
| Конфликт оптимизаторов | ⚠️ → ✅ | Выбран один |
| Нет обработки ошибок | ❌ → ✅ | Добавлены try-except |
| Нет проверки CUDA | ⚠️ → ✅ | Полная валидация GPU |
| Отсутствие логирования | ⚠️ → ✅ | Подробные сообщения |

---

**Дата:** 2026-04-25  
**Статус:** ✅ Исправлено
