## How I work

See elk_planner/CLAUDE.md for my general working style and paradigm —
the same rules apply here.

## What this package is

The picker UI (inline widget, bottom sheet, theme extension) used by elk_planner.
Icon data, `LucideIcon` and `IconSearchService` live in the sibling package
`../elk_lucide_icons` (own repo) — read its CLAUDE.md before touching icon data,
the generator, or search. The barrel re-exports it.
Local path dependency: declared in elk_planner/pubspec.yaml as
`../packages/elk_icon_picker`.

## Rules

- No external dependencies besides `elk_lucide_icons` (split out 2026-09-29). Ask before adding anything.
- Public API is the barrel file lib/elk_icon_picker.dart — any new
  public class or function must be exported there.
- ElkIconPickerThemeData is the integration point with the host app —
  don't reach into host app theme directly.

## Commands

| Task | Command |
|------|---------|
| Run tests | `flutter test` |
| Analyze | `flutter analyze` |
| Format | `dart format lib/` |

## Architecture

See FILES.md for the full file index. Quick summary:
- `lib/elk_icon_picker.dart` — public barrel file (only export point)
- `lib/src/widgets/elk_icon_picker_theme.dart` — `ElkIconPickerThemeData` ThemeExtension
- `lib/src/widgets/elk_icon_picker.dart` — main inline picker widget
- `lib/src/widgets/elk_icon_picker_sheet.dart` — `showElkIconPicker()` bottom sheet wrapper

## Gotchas

- `pubspec.yaml` depends on hosted `elk_lucide_icons`; the gitignored `pubspec_overrides.yaml`
  (root and `example/`) points it at `../elk_lucide_icons` for local dev. Publish
  `elk_lucide_icons` first whenever the picker needs a new version of it.
- Theme resolution in `ElkIconPicker`: explicit constructor param > `ElkIconPickerThemeData`
  from `ThemeData.extensions` > M3 `ColorScheme`/`TextTheme` fallback.
- `lerpDouble` is defined locally in `elk_icon_picker_theme.dart` (not imported from `dart:ui`)
  because the package avoids reaching into platform internals.
- `_tabBarScrollOffset` / `_tabBarMaxScrollExtent` in `_ElkIconPickerState` track the tab bar's
  scroll position via `NotificationListener<ScrollNotification>` for the edge fade overlays.
  Both are reset to `0.0` / `1.0` whenever `_recreateTabController()` is called so the right
  fade re-appears correctly after a category-set change.
- Swipe-to-change-category uses `GestureDetector.onHorizontalDragEnd` wrapping the `GridView`.
  Flutter's gesture arena resolves horizontal vs. vertical drags automatically — no special
  configuration needed.

## Maintenance rule

At the end of any session where files were added, renamed, moved,
or deleted: update this CLAUDE.md and FILES.md accordingly.