# ⚡ Quick Start Guide - Сохранение заметок

## Для нетерпеливых (30 секунд)

### 1. Создать новую заметку
```dart
// В любом месте приложения
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NoteEditor(),
  ),
);
```

### 2. Открыть существующую заметку
```dart
// noteId можно получить из БД или списка
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NoteEditor(noteId: savedNoteId),
  ),
);
```

### 3. Все! 🎉
Заметка автоматически сохраняется каждые 2 секунды.

---

## Полезные функции

### Получить текущую заметку
```dart
final viewModel = context.read<NoteEditorViewModel>();
final note = viewModel.currentNote;
print(note.title);
```

### Сохранить сейчас (без ожидания)
```dart
final viewModel = context.read<NoteEditorViewModel>();
await viewModel.saveNow();
```

### Проверить статус сохранения
```dart
Consumer<NoteEditorViewModel>(
  builder: (context, viewModel, _) {
    if (viewModel.isSaving) {
      return Text('Сохраняется...');
    }
    if (viewModel.errorMessage != null) {
      return Text('Ошибка: ${viewModel.errorMessage}');
    }
    return Text('Сохранено');
  },
)
```

---

## Интеграция с существующим UI

### Вариант 1: Замена текущего редактора
```dart
// Найти где используется старый NoteEditor
// Заменить на:

const NoteEditor()  // Новый с сохранением
```

### Вариант 2: Добавить кнопку "Сохранить"
```dart
FloatingActionButton(
  onPressed: () {
    context.read<NoteEditorViewModel>().saveNow();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Сохранено')),
    );
  },
  child: const Icon(Icons.save),
)
```

### Вариант 3: Стерео кнопки
```dart
Row(
  children: [
    ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Закрыть'),
    ),
    ElevatedButton(
      onPressed: () {
        context.read<NoteEditorViewModel>().saveNow();
      },
      child: const Text('Сохранить'),
    ),
  ],
)
```

---

## Типичные сценарии использования

### Сценарий 1: Главная страница с новой заметкой
```dart
// main_screen.dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditor(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Нажмите + чтобы создать заметку'),
      ),
    );
  }
}
```

### Сценарий 2: Список заметок
```dart
// Когда реализуем список (Future work)
class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Для каждой заметки:
        ListTile(
          title: Text(note.title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditor(noteId: note.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
```

### Сценарий 3: Боковая панель с редактором
```dart
// sidebar_layout.dart
class SidebarWithEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Боковая панель
        SizedBox(
          width: 250,
          child: ListView(children: [/* список */]),
        ),
        // Редактор (заполняет остальное место)
        const Expanded(
          child: NoteEditor(),
        ),
      ],
    );
  }
}
```

---

## Решение проблем (первые шаги)

### "Нет кнопки сохранить"
→ Сохранение **автоматическое**! Просто пишите.

### "Где найти сохраненные заметки?"
→ Они в Hive БД. Загружаются автоматически при открытии.

### "Как получить ID заметки?"
```dart
final viewModel = context.read<NoteEditorViewModel>();
final noteId = viewModel.currentNote.id;
```

### "Как открыть конкретную заметку?"
```dart
NoteEditor(noteId: 'the-note-id-here')
```

---

## Структура данных

Каждая заметка содержит:
```
{
  id: "uuid-string",
  title: "Заголовок",
  description: "Описание (опционально)",
  content: "[{...}]",  // QuillDelta JSON
  tags: ["тег1", "тег2"],
  createdAt: "2026-04-23...",
  updatedAt: "2026-04-23..."
}
```

---

## Команды в терминале

```bash
# Установить зависимости (один раз)
dart pub get

# Сгенерировать адаптеры (один раз)
dart run build_runner build

# Запустить приложение
flutter run

# Если ошибки - очистить и заново
dart run build_runner clean
dart run build_runner build
```

---

## ✅ Чек-лист интеграции

- [ ] Импортирован `NoteEditor` в нужное место
- [ ] `NoteEditorProvider` создан в `main.dart`
- [ ] `Hive` инициализирован в `main()`
- [ ] `flutter run` работает без ошибок
- [ ] Можно создавать новую заметку
- [ ] Текст сохраняется (проверить через 2 сек паузу)
- [ ] Можно перезагрузить приложение и заметка остается

---

## Дополнительно

- 📖 [NOTES_SAVE_FEATURE.md](NOTES_SAVE_FEATURE.md) - Полная документация
- 💡 [USAGE_EXAMPLES.dart](USAGE_EXAMPLES.dart) - 8 примеров кода
- 🛣️ [ROADMAP_AND_TROUBLESHOOTING.md](ROADMAP_AND_TROUBLESHOOTING.md) - Развитие

---

## 🎯 Что происходит в фоне?

```
Пользователь печатает
    ↓
ViewModel обновляет состояние
    ↓
Дебаунс 2 секунды
    ↓
Отправить на сохранение
    ↓
Hive сохраняет в файл на диск
    ↓
✅ Готово, пользователь может закрыть приложение
```

---

**Готово! Теперь у вас есть рабочая система сохранения заметок 🎉**
