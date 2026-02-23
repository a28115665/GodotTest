# CLAUDE.md

## Project Overview

**GodotTest** is a Godot Engine project. This repository is in its initial setup phase.

## Repository Structure

```
GodotTest/
├── CLAUDE.md          # AI assistant guidance (this file)
├── project.godot      # Godot project configuration (to be created)
├── scenes/            # Scene files (.tscn)
├── scripts/           # GDScript files (.gd)
├── assets/            # Art, audio, fonts, and other resources
│   ├── sprites/
│   ├── audio/
│   └── fonts/
├── addons/            # Third-party plugins and extensions
└── export_presets.cfg # Export configuration
```

## Development Setup

### Prerequisites

- **Godot Engine 4.x** (download from https://godotengine.org)
- No additional build tools required — Godot handles compilation internally

### Opening the Project

1. Open Godot Engine
2. Click "Import" and navigate to this repository root
3. Select `project.godot` and open

### Running the Project

- Press **F5** in the Godot editor to run the main scene
- Press **F6** to run the currently open scene
- From command line: `godot --path . --main-scene <scene_path>`

## Language and Conventions

### GDScript

This project uses **GDScript** as its primary scripting language.

- Follow the [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- Use `snake_case` for variables, functions, and file names
- Use `PascalCase` for class names and node names
- Use `SCREAMING_SNAKE_CASE` for constants and enums
- Prefix private members with an underscore: `_private_var`, `_private_method()`
- Use static typing where possible: `var speed: float = 10.0`
- Use `@onready` for node references: `@onready var sprite: Sprite2D = $Sprite2D`
- Prefer signals over direct method calls for loose coupling

### File Naming

- Scene files: `snake_case.tscn`
- Script files: `snake_case.gd`
- Resource files: `snake_case.tres`
- Keep script files alongside or in `scripts/` directory
- Keep scene files in `scenes/` directory

### Scene Organization

- One root scene per major game entity
- Use inherited scenes for variants
- Attach scripts to root nodes of scenes
- Use `%UniqueNodeName` syntax for frequently accessed child nodes

## Architecture Patterns

### Node Structure

- Follow Godot's node-based composition pattern
- Prefer composition (child nodes) over deep inheritance
- Use autoloads (singletons) sparingly — only for truly global state
- Emit signals upward, call methods downward in the scene tree

### State Management

- Use enums for state machines
- Keep game state in dedicated autoload singletons when needed
- Avoid circular dependencies between scripts

## Testing

### Manual Testing

- Test scenes individually with **F6** before integration
- Use Godot's built-in debugger and remote scene inspector

### Automated Testing (if GUT is added)

- Test files go in `res://tests/`
- Test scripts named `test_<feature>.gd`
- Run via the GUT panel in the editor or CLI: `godot --headless -s addons/gut/gut_cmdln.gd`

## Common Commands

```bash
# Run the project headless (for CI or testing)
godot --path . --headless

# Export for a platform (requires export presets)
godot --path . --export-release "<preset_name>" <output_path>

# Run GUT tests (if installed)
godot --path . --headless -s addons/gut/gut_cmdln.gd
```

## Key Files

| File | Purpose |
|------|---------|
| `project.godot` | Main project configuration, autoloads, input maps |
| `export_presets.cfg` | Platform export settings |
| `.godot/` | Editor cache (gitignored) |
| `default_env.tres` | Default environment/rendering settings |

## Git Conventions

- The `.godot/` directory should be gitignored (editor cache)
- Binary assets (images, audio) are tracked in git directly
- Scene (`.tscn`) and resource (`.tres`) files are text-based and diffable
- Commit messages should be concise and descriptive

## Notes for AI Assistants

- Godot uses its own scene format (`.tscn`) — these are text-based and editable but follow a specific format. Be careful when editing them directly.
- GDScript is Python-like but not Python. Key differences: `@export`, `@onready`, `signal`, `await`, `$NodePath` syntax.
- Node references via `$` or `get_node()` only work at runtime after `_ready()`.
- The `_process(delta)` and `_physics_process(delta)` functions are the main game loop callbacks.
- Prefer `_physics_process` for movement and collision logic; `_process` for visual updates.
- Resource paths start with `res://` (e.g., `res://scenes/player.tscn`).
