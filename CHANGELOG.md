## 0.2.0

* Split the Lucide icon data into its own package,
  [`elk_lucide_icons`](https://pub.dev/packages/elk_lucide_icons), now this
  package's only dependency. `LucideIcon`, `LucideIcons`, `LucideIconData`,
  `LucideCategory`, `IconSearchService`, `kLucideIcons`, `kLucideCategories`
  and `kLucideIconAliases` moved there and are re-exported, so
  `import 'package:elk_icon_picker/elk_icon_picker.dart'` works as before.
  Code that imported `package:elk_icon_picker/src/...` paths directly must
  switch to the barrel import.
* `CategoryStyle` moved to its own file (still exported from the barrel).

## 0.1.4

* Refreshed the Lucide icon registry against current upstream data (1748 ->
  1856 icons).
* Icons Lucide has renamed upstream keep working: each old name gets a
  deprecated `LucideIcons` constant (e.g. `LucideIcons.smile` ->
  `LucideIcons.faceSlightlySmiling`), and the new `kLucideIconAliases` map
  resolves old names saved as strings.
* Added `IconSearchService.findByName()`, which looks up an icon by name,
  including renamed ones, and returns `null` instead of throwing for unknown
  names.
* The SVG path tokenizer now compiles its regular expression once instead of
  on every call.
* The icon generator can read from a local Lucide checkout
  (`--source=<dir>`), pinning the output to that checkout's commit.
* Fixed the README example referencing `LucideIcons.home`, which Lucide
  renamed to `house`.

## 0.1.3

* Added a dartdoc comment to every generated `LucideIcons` constant, raising
  pub.dev's public API documentation coverage from 5.5% to 98.9% (full score
  on the "20% or more of the public API has dartdoc comments" check).

## 0.1.2

* Fixed README screenshots not rendering on pub.dev (relative image paths aren't
  reliably resolved there; switched to absolute GitHub URLs per pub.dev's own
  guidance).
* Refreshed the Lucide icon registry against current upstream data (1694 -> 1748
  icons) using a new reproducible generator (`tool/generate_lucide_icons.dart`).
* Fixed a broken `repository` link in `pubspec.yaml`.
* Trimmed the published package archive by excluding the example app's platform
  scaffolding (563 KB -> 303 KB).

## 0.1.1

* Improved Lucide icon registry generation.
* Removed unnecessary `const` keywords in generated data.
* Fixed string escaping in generated icon paths.

## 0.1.0

* Initial release of `elk_icon_picker`.
* Support for indexing and searching Lucide icons.
* CustomPainter rendering for high performance and zero dependencies.
* Added `showElkIconPicker` modal sheet.
* Added `LucideIcon` widget.
