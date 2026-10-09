# QTE56 Wizard Generator

> ↑ Навигация: [AGENTS.md](../AGENTS.md)

Desktop application for generating Qt 5.13.2 applications (D language) using a step-by-step wizard system.

**Status:** Actively developed — Main Window, Dialog, Tray, Console+GUI, DataView, TextEditor, Form, Class and Feature (network/threading/timer/fileops/process) wizards implemented

## Project Structure

```
qte56_wizard_generator/
├── src/
│   ├── main.d                      # Entry point
│   ├── model/
│   │   ├── option_types.d          # Enums, structs (Toggle, SingleChoice, etc.)
│   │   └── wizard_state.d          # WizardState class (current wizard state)
│   ├── appcore/
│   │   ├── preset_manager.d        # Presets (.qwiz) management
│   │   └── project_io.d            # Save/load .qwiz projects (JSON)
│   ├── wizards/
│   │   ├── wizard_registry.d       # Registry of all available wizards
│   │   ├── app/
│   │   │   ├── mainwindow_wizard.d # Main Window wizard definition (7 steps)
│   │   │   ├── dialog_wizard.d     # Dialog wizard
│   │   │   ├── tray_wizard.d       # Tray application wizard
│   │   │   └── console_gui_wizard.d# Console+GUI wizard
│   │   ├── widget/
│   │   │   ├── dataview_wizard.d   # Tree/Table/List wizard
│   │   │   ├── texteditor_wizard.d # Text editor wizard
│   │   │   ├── form_wizard.d       # Input form wizard
│   │   │   └── class_wizard.d      # Custom class wizard
│   │   └── feature/
│   │       ├── network_wizard.d    # HTTP client wizard
│   │       ├── threading_wizard.d  # Threading wizard
│   │       ├── timer_wizard.d      # Timer wizard
│   │       ├── fileops_wizard.d    # File operations wizard
│   │       └── process_wizard.d    # QProcess wizard
│   ├── codegen/
│   │   ├── generator.d             # CodeGenerator (D code generation)
│   │   └── imports_resolver.d      # Auto-resolve imports by component
│   └── ui/
│       ├── mainwindow.d            # Main window UI (layout, callbacks)
│       └── d_highlighter.d         # D syntax highlighting (QSyntaxHighlighter)
├── templates/                      # Ready app templates (tpl_*.d)
├── resources/presets/              # Preset .qwiz files
├── out/                            # Generated output
├── test/                           # Codegen tests
├── build.bat                       # Build script (Windows, 32-bit DMD)
└── README.md                       # This file
```

## Features

### Main Window Wizard
7 steps to generate a complete QMainWindow application:

1. **Document Architecture**
   - Choose: SDI, MDI, TDI, or Workspace
   - Set window title, size
   
2. **File Menu**
   - Include/exclude File menu actions
   - New, Open, Save, Save As, Close, Exit
   - Optional: Recent files, exit confirmation
   
3. **Edit Menu**
   - Edit menu actions: Undo/Redo, Cut/Copy/Paste, Find/Replace
   - Select All, Preferences
   
4. **Window Structure**
   - Optional: Toolbar, Status Bar
   - Optional: Dock panels (left/right)
   - Optional: Save/restore geometry
   - Optional: GC.collect() before exit
   
5. **View Menu**
   - View menu actions
   
6. **Help Menu**
   - Help menu actions (About, etc.)
   
7. **Summary**
   - Review configuration
   - Export generated D code

Другие визарды: Dialog, Tray Application, Console+GUI (app/);
DataView, TextEditor, Form, Class (widget/);
Network, Threading, Timer, File Operations, Process (feature/).

### Code Generation
- Automatically generates valid, compilable D code
- Correct imports based on selected components
- Proper QTE56 patterns: `__gshared`, `cast(void*)null`, `disown()`, ESlot callbacks
- Signal connections for menus and actions
- Proper main() structure with LoadQt, QApplication lifecycle

### User Interface
- **Left Panel:**
  - Wizard steps list (navigation)
  - Wizard tree (Applications, Widgets, Features categories)
  
- **Right Panel (Top):** Dynamic step content
  - QCheckBox for Toggle options
  - QRadioButton groups for SingleChoice
  - QLineEdit for Text options
  - QSpinBox for Number options
  
- **Right Panel (Bottom):** Code preview
  - QTextEdit with monospace D code display
  - Copy button (copy to clipboard)
  - Export button (save to .d file)
  
- **Bottom Bar:** Navigation
  - Back / Next / Export buttons
  - Status messages

## Building

### Requirements
- **DMD 2.090+** (32-bit, `dmd -m32`)
- **Qt 5.13.2 MinGW 32-bit** DLLs at `../dll/`
- Standard D library

### Compile

From the project directory:

```bash
build.bat              # Compile (creates wizard_generator.exe)
build.bat run          # Compile and run
build.bat clean        # Remove build artifacts
```

Or manually:
```bash
dmd -m32 -i src\main.d -Isrc -I..\d -I..\d\gen -of=wizard_generator.exe
```

### Run

```bash
set PATH=..\dll;%PATH%
wizard_generator.exe
```

(build.bat run does this automatically)

## Key Design Decisions

### No dependencies between options
- Options don't enable/disable each other yet
- Full configuration graph is planned

### __gshared globals for all widgets
- Required for QTE56 callback pattern
- ESlot pool for dynamic option widgets
- Widget binding table (handle → option ID) for callback dispatch

### Code generation via templates
- ImportsResolver: component → required imports
- CodeGenerator: wizard state → full D code
- Supports: QMainWindow, menus, toolbars, statusbar, docks

### QTextEdit for code preview
- D syntax highlighting via QSyntaxHighlighter (`ui/d_highlighter.d`, VSCode Dark+ theme)
- QScintilla remains a possible future upgrade

## Using the Generated Code

Example output of Main Window wizard (SDI + File + Edit menus):

```d
// Generated by QTE56 Wizard Generator
import qte56_core;
import qte56_loader;
// ... (all necessary imports)

__gshared QMainWindow g_win;
__gshared QAction g_actNew;
__gshared QAction g_actOpen;
__gshared ESlot[32] g_slots;

extern(C) void onFileNew(void* dt, int n, int c) { /* TODO */ }
extern(C) void onFileOpen(void* dt, int n, int c) { /* TODO */ }

void main() {
    LoadQt("./dll");
    auto app = new QApplication();
    
    g_win = new QMainWindow(cast(void*)null);
    // ... setup menus, toolbars, etc.
    
    g_win.show();
    app.exec();
    GC.collect();
    app.deleteApp();
}
```

The generated code is ready to:
1. Copy from the preview panel
2. Save to a .d file
3. Compile with your own DLL setup
4. Modify and extend

## Roadmap

- [x] Additional wizards: Dialog, Tray, DataView, TextEditor (+ Form, Class, Feature-визарды)
- [ ] Option dependencies (enable/disable based on previous choices)
- [x] D syntax highlighting in code preview (QSyntaxHighlighter; QScintilla — опционально)
- [x] Save/load project files (.qwiz format)
- [x] Presets for common configurations (`resources/presets/`, `templates/`)
- [ ] Advanced: multiple output files

## Notes

- **GC management:** Always call `GC.collect()` before `app.deleteApp()` to avoid finalization crashes
- **ESlot callbacks:** Correct signature is `(void* dthis, int n, int value)` for invoke_i, not just 2 args
- **Disown pattern:** Typed layout methods (`addWidget`, `setLayout`) automatically call `disown()`
- **QTE56 patterns:** See `AI_CONTEXT.md` in parent directory for full QTE56 API reference

## Architecture Notes

### Model-View-Controller
- **Model:** `WizardState`, `WizardDef` (pure D, no Qt)
- **View:** UI components in `mainwindow.d`
- **Controller:** Callbacks dispatch events to `WizardState` and `CodeGenerator`

### Code Generation Pipeline
1. User makes choice in step page
2. WizardState.setValue() updates
3. updatePreview() calls CodeGenerator.generate()
4. CodeGenerator produces D code
5. QTextEdit displays it live

### ESlot Pattern (QTE56)
```d
__gshared ESlot g_slot;

extern(C) void onClicked(void* dthis, int n, int checked) { }

g_slot = new ESlot(button.getWH());
g_slot.set(cast(void*)&onClicked);
button.connect_clicked(g_slot);
```

## License

Part of the QTE56 project. D language, Qt 5.13.2 bindings.

---

**Created:** 2026-04-16  
**Updated:** 2026-08-02 — структура, список визардов и roadmap приведены к текущему состоянию

---

## Навигация

- ↑ [AGENTS.md](../AGENTS.md) — точка входа
- ↓ Подробнее:
  - [QTE56_WIZARD_SPECIFICATION.md](../QTE56_WIZARD_SPECIFICATION.md) — спецификация визардов
