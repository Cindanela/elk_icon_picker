# Worklog

## 2026-11-03 — Rename elk_lucide_icons → elk_stroke_icons
- Icons package renamed before its first pub.dev publish so the name doesn't read as official Lucide;
  GitHub repo and local folder renamed too (GitHub redirects the old URL).
- Dart API names (`LucideIcon`, `LucideIcons`, `kLucide*`) kept — they name the icon set; no host-app churn.
- "Unofficial — not affiliated with Lucide" line added to both READMEs.
- Picker README links now point to pub.dev; publish `elk_stroke_icons` 0.1.0 first, then picker 0.2.0.

## 2026-09-29 — Split icon data into elk_lucide_icons

- Moved Lucide data, `LucideIcon`, `LucideIconData`, `LucideCategory`, `IconSearchService`, SVG
  parser, generator and the weekly Lucide-drift workflow to new sibling repo `../elk_lucide_icons` (0.1.0).
- Picker 0.2.0 depends on hosted `elk_lucide_icons: ^0.1.0` and re-exports it; `CategoryStyle`
  moved to `lib/src/models/category_style.dart`.
- Local dev via gitignored `pubspec_overrides.yaml` (picker root, `example/`, and elk_planner).
- Not yet published: `elk_lucide_icons` must go to pub.dev before picker 0.2.0.
