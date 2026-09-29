# Worklog

## 2026-09-29 — Split icon data into elk_lucide_icons

- Moved Lucide data, `LucideIcon`, `LucideIconData`, `LucideCategory`, `IconSearchService`, SVG
  parser, generator and the weekly Lucide-drift workflow to new sibling repo `../elk_lucide_icons` (0.1.0).
- Picker 0.2.0 depends on hosted `elk_lucide_icons: ^0.1.0` and re-exports it; `CategoryStyle`
  moved to `lib/src/models/category_style.dart`.
- Local dev via gitignored `pubspec_overrides.yaml` (picker root, `example/`, and elk_planner).
- Not yet published: `elk_lucide_icons` must go to pub.dev before picker 0.2.0.
