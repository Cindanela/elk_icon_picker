import 'package:flutter/material.dart';

/// Theme data for [ElkIconPicker] and [showElkIconPicker].
///
/// Add this to your app's [ThemeData.extensions] to style all pickers globally:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
///     extensions: [
///       ElkIconPickerThemeData(
///         selectedColor: Colors.teal,
///         tabLabelStyle: TextStyle(fontFamily: 'Inter'),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// Any value left null falls back to the ambient Material 3 [ColorScheme] or
/// [TextTheme].  Per-widget constructor params take priority over this theme.
class ElkIconPickerThemeData extends ThemeExtension<ElkIconPickerThemeData> {
  /// Background color of the picker surface and bottom sheet container.
  final Color? backgroundColor;

  /// Color used for unselected icons.
  final Color? iconColor;

  /// Color used for the selected icon highlight border and fill.
  final Color? selectedColor;

  /// Corner radius applied to the selected icon indicator and sheet handle.
  final double? borderRadius;

  /// Text style for the search field input text.
  final TextStyle? searchStyle;

  /// Text style for the search field hint ("Search icons...").
  final TextStyle? searchHintStyle;

  /// Text style for the category tab labels.
  final TextStyle? tabLabelStyle;

  /// Text style for the bottom sheet title ("Select Icon").
  final TextStyle? titleStyle;

  /// Text style for the empty-state message shown when no icons match.
  final TextStyle? emptyStateStyle;

  /// Stroke width for icon rendering. Defaults to `2.0`.
  final double? iconStrokeWidth;

  /// Whether icons use rounded stroke caps and joins. Defaults to `true`.
  final bool? iconRounded;

  const ElkIconPickerThemeData({
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
    this.borderRadius,
    this.searchStyle,
    this.searchHintStyle,
    this.tabLabelStyle,
    this.titleStyle,
    this.emptyStateStyle,
    this.iconStrokeWidth,
    this.iconRounded,
  });

  @override
  ElkIconPickerThemeData copyWith({
    Color? backgroundColor,
    Color? iconColor,
    Color? selectedColor,
    double? borderRadius,
    TextStyle? searchStyle,
    TextStyle? searchHintStyle,
    TextStyle? tabLabelStyle,
    TextStyle? titleStyle,
    TextStyle? emptyStateStyle,
    double? iconStrokeWidth,
    bool? iconRounded,
  }) {
    return ElkIconPickerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      selectedColor: selectedColor ?? this.selectedColor,
      borderRadius: borderRadius ?? this.borderRadius,
      searchStyle: searchStyle ?? this.searchStyle,
      searchHintStyle: searchHintStyle ?? this.searchHintStyle,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      emptyStateStyle: emptyStateStyle ?? this.emptyStateStyle,
      iconStrokeWidth: iconStrokeWidth ?? this.iconStrokeWidth,
      iconRounded: iconRounded ?? this.iconRounded,
    );
  }

  @override
  ElkIconPickerThemeData lerp(ElkIconPickerThemeData? other, double t) {
    if (other == null) return this;
    return ElkIconPickerThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      searchStyle: TextStyle.lerp(searchStyle, other.searchStyle, t),
      searchHintStyle: TextStyle.lerp(searchHintStyle, other.searchHintStyle, t),
      tabLabelStyle: TextStyle.lerp(tabLabelStyle, other.tabLabelStyle, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      emptyStateStyle: TextStyle.lerp(emptyStateStyle, other.emptyStateStyle, t),
      iconStrokeWidth: lerpDouble(iconStrokeWidth, other.iconStrokeWidth, t),
      // bool snaps at midpoint — standard Flutter convention
      iconRounded: t < 0.5 ? iconRounded : other.iconRounded,
    );
  }
}

/// Linearly interpolates between two doubles, handling nulls gracefully.
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  return (a ?? b)! + ((b ?? a)! - (a ?? b)!) * t;
}
