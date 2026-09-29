# File index — elk_icon_picker

Last updated: 2026-09-29

> Maintenance: ask Claude Code to update this file at the end of any
> session where files were added, renamed, moved, or deleted.

Icon data, `LucideIcon`, `IconSearchService` and the generator live in
`../elk_lucide_icons` — see its FILES.md.

---

### Config

| File | Path | What it does |
|------|------|-------------|
| `analysis_options.yaml` | `analysis_options.yaml` | Linter rules for code quality within the package. |
| `pubspec.yaml` | `pubspec.yaml` | Package manifest — only dependency is `elk_lucide_icons`. |
| `pubspec_overrides.yaml` | `pubspec_overrides.yaml`, `example/pubspec_overrides.yaml` | Gitignored, local only — points `elk_lucide_icons` at the sibling checkout. |
| `elk_icon_picker.dart` | `lib/elk_icon_picker.dart` | Public API barrel file; re-exports `elk_lucide_icons`. |

### Theme

| File | Path | What it does |
|------|------|-------------|
| `elk_icon_picker_theme.dart` | `lib/src/widgets/elk_icon_picker_theme.dart` | ElkIconPickerThemeData ThemeExtension — customises picker colors, text styles, border radius, icon stroke, category tab width, edge fade, and swipe-to-change-category behaviour. |

### Models

| File | Path | What it does |
|------|------|-------------|
| `icon_source.dart` | `lib/src/models/icon_source.dart` | Sealed IconSelection base class with subclasses: LucideIconSelection, EmojiSelection, ImportedIconSelection, BundledIconSelection. |
| `category_style.dart` | `lib/src/models/category_style.dart` | CategoryStyle enum (both, iconsOnly, textOnly) for category tab layout. |

### Tests

| File | Path | What it does |
|------|------|-------------|
| `icon_source_test.dart` | `test/src/models/icon_source_test.dart` | Equality/hashCode tests for every IconSelection subclass. |

### Widgets

| File | Path | What it does |
|------|------|-------------|
| `elk_icon_picker.dart` | `lib/src/widgets/elk_icon_picker.dart` | Main inline picker widget with search bar, category tabs (with edge fade overlays), scrollable icon grid, selection indicator, and swipe-to-change-category gesture. |
| `elk_icon_picker_sheet.dart` | `lib/src/widgets/elk_icon_picker_sheet.dart` | showElkIconPicker() — wraps ElkIconPicker in a draggable bottom sheet with title bar and pull handle. |
| `icon_selection_preview.dart` | `lib/src/widgets/icon_selection_preview.dart` | Renders any IconSelection variant (Lucide, emoji, imported font icon, bundled SVG) in a unified preview tile. |
