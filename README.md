# elk_icon_picker

[![Pub Version](https://img.shields.io/pub/v/elk_icon_picker?style=for-the-badge)](https://pub.dev/packages/elk_icon_picker)
[![License](https://img.shields.io/badge/license-MIT%20/%20ISC-blue.svg?style=for-the-badge)](LICENSE)

A high-performance, reusable, and **dependency-free** Flutter package for picking Lucide icons. Renders icons via `CustomPainter` from generated Dart data, ensuring zero impact on your app's font or SVG asset overhead.

![Mockup](elk_icon_picker_mockup_1774783608858.png)

## Features

- 🚀 **Performance**: Icons are rendered using `CustomPainter` with standard Flutter `Canvas` commands.
- 📦 **Zero Dependencies**: Does not depend on `flutter_svg`, `lucide_icons`, or any other third-party package.
- 🎨 **Fully Customizable**: Control colors, sizes, stroke widths, rounded caps/joins, and fonts — globally via `ThemeData` or per-widget.
- 🔍 **Searchable**: Built-in fuzzy search and categorized icon browsing.
- 📱 **Adaptive UI**: Works beautifully as an inline widget or a professional bottom sheet.
- 🛠 **Generated Data**: Uses a custom build tool to convert Lucide SVG paths into optimized Dart draw commands.

## Why CustomPainter?

Unlike traditional icon fonts or SVG assets, `elk_icon_picker` uses `CustomPainter` to draw icons. This provides several advantages:
1. **No Font Bloat**: You don't need to ship large `.ttf` or `.otf` files.
2. **Dynamic Styling**: Stroke width and rounding can be changed at runtime without pixelation.
3. **Optimized Payloads**: Only the raw path data is stored in the Dart binary, which is highly compressible.
4. **Memory Efficient**: No SVG parsing at runtime for most icons (complex paths are cached).

## Getting Started

Add `elk_icon_picker` to your `pubspec.yaml`:

```yaml
dependencies:
  elk_icon_picker: ^0.1.1
```

## Usage

### Show as a Modal Sheet

The quickest way to integrate the picker is using the `showElkIconPicker` helper function.

```dart
import 'package:elk_icon_picker/elk_icon_picker.dart';

void _selectIcon() async {
  final selection = await showElkIconPicker(
    context,
    currentSelection: _mySelection,
    selectedColor: Theme.of(context).primaryColor,
  );

  if (selection is LucideIconSelection) {
    setState(() {
      _mySelection = selection;
    });
  }
}
```

### Use Inline Widget

You can also embed the `ElkIconPicker` directly into your layouts.

```dart
ElkIconPicker(
  onSelected: (selection) {
    print('Selected: ${selection.name}');
  },
  crossAxisCount: 6,
  borderRadius: 12.0,
)
```

### Displaying the Selected Icon

Use the `LucideIcon` widget to render the selected icon data.

```dart
LucideIcon(
  LucideIcons.home,
  size: 32,
  color: Colors.blue,
  strokeWidth: 2.5,
)
```

## Theming

You can style all pickers in one place by adding `ElkIconPickerThemeData` to your app's `ThemeData.extensions`. This integrates naturally with Material 3 light/dark themes — just provide a different extension in your dark theme.

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    extensions: [
      ElkIconPickerThemeData(
        selectedColor: Colors.teal,
        backgroundColor: Colors.white,
        iconColor: Colors.black54,
        borderRadius: 12.0,
        searchStyle: TextStyle(fontFamily: 'Inter'),
        searchHintStyle: TextStyle(fontFamily: 'Inter', color: Colors.grey),
        tabLabelStyle: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        titleStyle: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold),
        emptyStateStyle: TextStyle(fontFamily: 'Inter', color: Colors.grey),
      ),
    ],
  ),
  darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
    extensions: [
      ElkIconPickerThemeData(
        selectedColor: Colors.tealAccent,
        backgroundColor: Color(0xFF1E1E1E),
        iconColor: Colors.white70,
      ),
    ],
  ),
)
```

Values are resolved in this priority order:

1. **Explicit constructor param** — highest priority, overrides everything
2. **`ElkIconPickerThemeData` extension** — global app theme
3. **Material 3 `ColorScheme` / `TextTheme`** — automatic fallback

So you can set defaults globally and still override individual pickers when needed:

```dart
// Uses the global theme
showElkIconPicker(context);

// Overrides just the selected color for this instance
showElkIconPicker(context, selectedColor: Colors.orange);
```

### `ElkIconPickerThemeData` properties

| Property | Description |
|----------|-------------|
| `backgroundColor` | Background color of the picker and bottom sheet container |
| `iconColor` | Color for unselected icons |
| `selectedColor` | Color for the selected icon highlight |
| `borderRadius` | Corner radius for selection indicators and the sheet |
| `searchStyle` | Text style for the search field input |
| `searchHintStyle` | Text style for the search field hint text |
| `tabLabelStyle` | Text style for category tab labels |
| `titleStyle` | Text style for the bottom sheet title ("Select Icon") |
| `emptyStateStyle` | Text style for the "no results" message |
| `iconStrokeWidth` | Stroke width for icon rendering (e.g. `1.5` for thin, `2.5` for bold) |
| `iconRounded` | Whether icons use rounded stroke caps and joins |

## Customization

Per-widget constructor params work exactly as before. These take priority over any theme extension.

| Property | Description | Default |
|----------|-------------|---------|
| `crossAxisCount` | Number of columns in the grid | `5` |
| `iconColor` | Color for unselected icons | from theme, then `iconTheme.color` |
| `selectedColor` | Color for the selected icon/indicator | from theme, then `colorScheme.primary` |
| `backgroundColor` | Background color of the picker | from theme, then `transparent` |
| `borderRadius` | Curvature of selection boxes | from theme, then `8.0` (`12.0` for sheet) |
| `iconStrokeWidth` | Stroke width for icon rendering | from theme, then `2.0` |
| `iconRounded` | Rounded stroke caps/joins on icons | from theme, then `true` |
| `showSearch` | Whether to show the search bar | `true` |
| `showCategories` | Whether to show the category tabs | `true` |
| `categoryStyle` | Tab layout: `both`, `iconsOnly`, or `textOnly` | `both` |
| `allowedCategoryIds` | Limit which categories appear (e.g. `['arrows', 'shapes']`). `null` shows all | `null` |
| `allowUserToggleCategories` | Show a toggle button so the end user can hide/show the category tabs | `false` |

## License

- The picker code is licensed under the [MIT License](LICENSE).
- Lucide icon data is provided under the [ISC License](LICENSE-LUCIDE).
