# File index — elk_icon_picker

Last updated: 2026-09-29

> Maintenance: ask Claude Code to update this file at the end of any
> session where files were added, renamed, moved, or deleted.

---

### Config

| File | Path | What it does |
|------|------|-------------|
| `analysis_options.yaml` | `analysis_options.yaml` | Linter rules for code quality within the package. |
| `pubspec.yaml` | `pubspec.yaml` | Package manifest — no external dependencies, declares package name and SDK constraint. |
| `elk_icon_picker.dart` | `lib/elk_icon_picker.dart` | Public API barrel file re-exporting all models, services, utilities, and widgets. |

### Theme

| File | Path | What it does |
|------|------|-------------|
| `elk_icon_picker_theme.dart` | `lib/src/widgets/elk_icon_picker_theme.dart` | ElkIconPickerThemeData ThemeExtension — customises picker colors, text styles, border radius, icon stroke, category tab width, edge fade, and swipe-to-change-category behaviour. |

### Services

| File | Path | What it does |
|------|------|-------------|
| `icon_search_service.dart` | `lib/src/services/icon_search_service.dart` | IconSearchService.filter() — searches the icon catalogue by name/tags, optionally limited to a category. IconSearchService.findByName() — looks up an icon by name, resolving names Lucide has renamed via kLucideIconAliases. |

### Models

| File | Path | What it does |
|------|------|-------------|
| `icon_source.dart` | `lib/src/models/icon_source.dart` | Sealed IconSelection base class with subclasses: LucideIconSelection, EmojiSelection, ImportedIconSelection, BundledIconSelection. |
| `lucide_category.dart` | `lib/src/models/lucide_category.dart` | LucideCategory: id, title, representative icon; CategoryStyle enum (both, iconsOnly, textOnly). |
| `lucide_icon_data.dart` | `lib/src/models/lucide_icon_data.dart` | LucideIconData storing SVG shape primitives (circles, ellipses, lines, rects, polylines, polygons, paths) as typed tuples with tags and category membership. |

### Utils

| File | Path | What it does |
|------|------|-------------|
| `svg_path_parser.dart` | `lib/src/utils/svg_path_parser.dart` | parseSvgPath() — converts SVG path d-attribute string to Flutter Path, supporting all standard commands (M, L, H, V, C, S, Q, T, A, Z). |

### Tool

| File | Path | What it does |
|------|------|-------------|
| `generate_lucide_icons.dart` | `tool/generate_lucide_icons.dart` | Regenerates `lib/src/gen/lucide_icons.g.dart` from Lucide's published SVG + JSON source on GitHub. Zero dependencies (dart:io/dart:convert). Run with `dart run tool/generate_lucide_icons.dart`, or `--source=<dir>` to read a local Lucide checkout. Also emits deprecated constants and `kLucideIconAliases` for renamed icons. |

### Tests

| File | Path | What it does |
|------|------|-------------|
| `icon_search_service_test.dart` | `test/src/services/icon_search_service_test.dart` | Tests for IconSearchService.filter() (empty/whitespace queries, category filter) and findByName() (current names, renamed names, unknown names, alias integrity). |

### Widgets

| File | Path | What it does |
|------|------|-------------|
| `elk_icon_picker.dart` | `lib/src/widgets/elk_icon_picker.dart` | Main inline picker widget with search bar, category tabs (with edge fade overlays), scrollable icon grid, selection indicator, and swipe-to-change-category gesture. |
| `elk_icon_picker_sheet.dart` | `lib/src/widgets/elk_icon_picker_sheet.dart` | showElkIconPicker() — wraps ElkIconPicker in a draggable bottom sheet with title bar and pull handle. |
| `icon_selection_preview.dart` | `lib/src/widgets/icon_selection_preview.dart` | Renders any IconSelection variant (Lucide, emoji, imported font icon, bundled SVG) in a unified preview tile. |
| `lucide_icon.dart` | `lib/src/widgets/lucide_icon.dart` | LucideIcon widget — renders LucideIconData as a stroked 24×24 icon via CustomPainter with lazy SVG path parsing and result caching. |