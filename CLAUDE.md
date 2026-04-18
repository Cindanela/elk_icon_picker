## How I work

See elk_planner/CLAUDE.md for my general working style and paradigm —
the same rules apply here.

## What this package is

A standalone Flutter icon picker package used by elk_planner.
No external dependencies by design — keep it that way.
Local path dependency: declared in elk_planner/pubspec.yaml as
`../packages/elk_icon_picker`.

## Rules

- No external dependencies — ever. Ask before adding anything.
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
- `lib/src/gen/lucide_icons.g.dart` — **GENERATED, do not edit by hand**
- `lib/src/widgets/elk_icon_picker_theme.dart` — `ElkIconPickerThemeData` ThemeExtension
- `lib/src/widgets/elk_icon_picker.dart` — main inline picker widget
- `lib/src/widgets/elk_icon_picker_sheet.dart` — `showElkIconPicker()` bottom sheet wrapper

## Gotchas

- `lucide_icons.g.dart` is generated from SVG source data. The `tool/` directory is empty —
  there is no build_runner setup. Regeneration must be done manually (ask the user how before
  touching icon data).
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