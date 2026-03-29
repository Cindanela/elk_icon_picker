# elk_icon_picker

[![Pub Version](https://img.shields.io/pub/v/elk_icon_picker?style=for-the-badge)](https://pub.dev/packages/elk_icon_picker)
[![License](https://img.shields.io/badge/license-MIT%20/%20ISC-blue.svg?style=for-the-badge)](LICENSE)

A high-performance, reusable, and **dependency-free** Flutter package for picking Lucide icons. Renders icons via `CustomPainter` from generated Dart data, ensuring zero impact on your app's font or SVG asset overhead.

![Mockup](elk_icon_picker_mockup_1774783608858.png)

## Features

- 🚀 **Performance**: Icons are rendered using `CustomPainter` with standard Flutter `Canvas` commands.
- 📦 **Zero Dependencies**: Does not depend on `flutter_svg`, `lucide_icons`, or any other third-party package.
- 🎨 **Fully Customizable**: Control colors, sizes, stroke widths, and rounded caps/joins.
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

## Customization

The `ElkIconPicker` supports various styling options:

| Property | Description | Default |
|----------|-------------|---------|
| `crossAxisCount` | Number of columns in the grid | `5` |
| `iconColor` | Color for unselected icons | `Theme.iconTheme.color` |
| `selectedColor` | Color for the selected icon/indicator | `Theme.primaryColor` |
| `backgroundColor` | Background color of the picker | `transparent` |
| `borderRadius` | Curvature of selection boxes | `8.0` |
| `showSearch` | Whether to show the search bar | `true` |
| `showCategories` | Whether to show the category tabs | `true` |
| `categoryStyle` | Tab layout: `both`, `iconsOnly`, or `textOnly` | `both` |

## License

- The picker code is licensed under the [MIT License](LICENSE).
- Lucide icon data is provided under the [ISC License](LICENSE-LUCIDE).
