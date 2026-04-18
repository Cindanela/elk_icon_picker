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

| Property | Description | Default |
|----------|-------------|---------|
| `data` | **Required**. The icon data to render (e.g., `LucideIcons.home`) | - |
| `size` | The size of the icon | `24` |
| `color` | The color of the icon's stroke | `IconTheme.of(context).color` |
| `strokeWidth` | The width of the icon's stroke | `2.0` |
| `rounded` | Whether to use rounded stroke caps and joins | `true` |

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
| `selectedColor`| Color for the selected icon highlight |
| `selectedIconColor` | Color of the icon stroke itself when selected |
| `iconSize` | Rendered size of each icon in the grid (default `24.0`) |
| `borderRadius` | Corner radius for selection indicators and the sheet |
| `searchStyle` | Text style for the search field input |
| `searchHintStyle` | Text style for the search field hint text |
| `tabLabelStyle` | Text style for category tab labels |
| `titleStyle` | Text style for the bottom sheet title ("Select Icon") |
| `emptyStateStyle` | Text style for the "no results" message |
| `iconStrokeWidth` | Stroke width for icon rendering (e.g. `1.5` for thin, `2.5` for bold) |
| `iconRounded` | Whether icons use rounded stroke caps and joins |
| `showSearch` | Whether the search bar is shown by default |
| `showCategories` | Whether category tabs are shown by default |
| `categoryStyle` | Default category tab layout style (`both`, `iconsOnly`, `textOnly`) |
| `allowUserToggleCategories` | Whether to show the toggle button for categories |
| `crossAxisCount` | Global override for the number of columns (default: adaptive) |
| `allowedCategoryIds` | Global filter for which categories to show |
| `categoryIconSize` | Rendered size of icons in the category tab bar (default `18.0`) |
| `categoryTextSpacing` | Spacing between icon and text in tabs (default `8.0`) |
| `gridPadding` | Padding around the main icon grid (default `EdgeInsets.all(16.0)`) |
| `searchBarFillColor` | Fill color of the search input field |
| `sheetHandleColor` | Color of the drag handle in the bottom sheet |
| `sheetTitleBarColor` | Background color of the title bar area in the sheet |
| `tabIndicatorColor` | Color of the selected tab underline/indicator |
| `categoryTabWidth` | Fixed width for each category tab — controls how many are visible at once |
| `showCategoryFade` | Show gradient fade at the edges of the tab bar when more tabs exist (default `true`) |
| `categoryFadeColor` | Color of the tab bar edge fade (defaults to the picker's background color) |
| `swipeCategoryOnGrid` | Allow horizontal swipes on the icon grid to change category (default `true`) |
| `swipeVelocityThreshold` | Minimum swipe velocity (px/s) to trigger a category change (default `300.0`) |

## Category navigation

### Edge fade

When the category tab bar has more tabs than fit in the viewport, gradient overlays appear at the left and/or right edges to signal that the bar is scrollable. The fade color automatically matches the picker background, so it blends seamlessly. Set `showCategoryFade: false` to disable it, or `categoryFadeColor` to override the color.

### Controlling visible tab count

Use `categoryTabWidth` to give all tabs a fixed width. For example, setting `categoryTabWidth: 110` on a 360dp-wide picker shows approximately three tabs at a time. Leave it null (the default) for natural intrinsic widths.

### Swipe to change category

By default, a fast horizontal swipe anywhere on the icon grid advances or retreats the active category — the same gesture that a tab bar swipe would produce. Flutter's gesture arena handles the disambiguation: vertical scrolling of the grid and horizontal category switching work without conflict. Use `swipeCategoryOnGrid: false` to disable, or `swipeVelocityThreshold` to tune the sensitivity.

## Customization

Per-widget constructor params work exactly as before. These take priority over any theme extension.

| Property | Description | Default |
|----------|-------------|---------|
| `onSelected` | **Required**. Callback when an icon is selected | - |
| `currentSelection` | The currently selected icon to highlight | `null` |
| `crossAxisCount` | Number of columns in the grid | from theme / adaptive |
| `iconColor` | Color for unselected icons | from theme |
| `selectedColor` | Color for the selected icon/indicator highlight | from theme |
| `selectedIconColor` | Color of the icon stroke itself when selected | from theme |
| `backgroundColor` | Background color of the picker | from theme |
| `borderRadius` | Curvature of selection boxes | from theme |
| `iconStrokeWidth` | Stroke width for icon rendering | from theme |
| `iconRounded` | Rounded stroke caps/joins on icons | from theme |
| `iconSize` | Size of icons in the grid | from theme |
| `searchBarFillColor` | Background color for the search bar | from theme |
| `tabIndicatorColor` | Color of the category tab indicator | from theme |
| `showSearch` | Whether to show the search bar | from theme |
| `showCategories` | Whether to show the category tabs | from theme |
| `categoryStyle` | Tab layout: `both`, `iconsOnly`, or `textOnly` | from theme |
| `allowedCategoryIds` | Limit which categories appear | from theme |
| `allowUserToggleCategories` | Show a user toggle for categories | from theme |
| `categoryIconSize` | Size of icons in the category tabs | from theme |
| `categoryTextSpacing` | Gap between icon and text in tabs | from theme |
| `gridPadding` | Padding around the icon grid | from theme |
| `scrollController` | Controller for the icon grid scroll | `null` |
| `categoryTabWidth` | Fixed width for each category tab | from theme |
| `showCategoryFade` | Show gradient fade at the tab bar edges | from theme (`true`) |
| `categoryFadeColor` | Color of the tab bar edge fade | from theme / bg |
| `swipeCategoryOnGrid` | Horizontal swipe on grid changes category | from theme (`true`) |
| `swipeVelocityThreshold` | Min swipe velocity to trigger category change | from theme (`300.0`) |

## License

- The picker code is licensed under the [MIT License](LICENSE).
- Lucide icon data is provided under the [ISC License](LICENSE-LUCIDE).
