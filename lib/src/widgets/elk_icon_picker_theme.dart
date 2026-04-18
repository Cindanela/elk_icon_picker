import 'package:flutter/material.dart';
import '../models/lucide_category.dart';

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

  /// Color used for the icon stroke itself when selected.
  /// Falls back to [selectedColor] when null.
  final Color? selectedIconColor;

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

  /// Rendered size of each icon in the grid. Defaults to `24.0`.
  final double? iconSize;

  /// Whether the search bar is shown by default. Defaults to `true`.
  final bool? showSearch;

  /// Whether category tabs are shown by default. Defaults to `true`.
  final bool? showCategories;

  /// How to display category tab labels. Defaults to [CategoryStyle.both].
  final CategoryStyle? categoryStyle;

  /// Whether to show the toggle button that lets users show/hide category tabs.
  /// Defaults to `false`.
  final bool? allowUserToggleCategories;

  /// The number of icons across in the grid.
  /// Overrides adaptive calculation when set.
  final int? crossAxisCount;

  /// Limits which categories appear in the tab bar globally.
  final List<String>? allowedCategoryIds;

  /// Rendered size of icons in the category tab bar. Defaults to `18.0`.
  final double? categoryIconSize;

  /// Spacing between the icon and text in a category tab. Defaults to `8.0`.
  final double? categoryTextSpacing;

  /// Padding around the main icon grid. Defaults to `EdgeInsets.all(16.0)`.
  final EdgeInsetsGeometry? gridPadding;

  /// The maximum width of a cell in the adaptive grid.
  /// Used by [SliverGridDelegateWithMaxCrossAxisExtent] to fill the width.
  /// Defaults to `iconSize * 2.5` when null.
  final double? maxCrossAxisExtent;

  /// Fill color of the search input field.
  /// Falls back to the ambient [InputDecorationTheme] when null.
  final Color? searchBarFillColor;

  /// Color of the drag handle in the bottom sheet.
  /// Falls back to `Colors.grey` at 30% opacity when null.
  final Color? sheetHandleColor;

  /// Background color of the title bar area (handle + title row) in the sheet.
  /// Falls back to [backgroundColor] when null.
  final Color? sheetTitleBarColor;

  /// Color of the selected tab underline/indicator.
  /// Falls back to the ambient [TabBarTheme.indicatorColor] when null.
  final Color? tabIndicatorColor;

  /// Fixed width for each category tab. When null, tabs use their natural
  /// intrinsic width. Setting this (e.g. `120.0`) makes all tabs the same
  /// width, giving predictable control over how many tabs are visible at once.
  final double? categoryTabWidth;

  /// Whether to show gradient fade overlays at the edges of the category tab
  /// bar to indicate more tabs exist beyond the visible viewport.
  /// Defaults to `true`.
  final bool? showCategoryFade;

  /// Color of the category tab bar edge fade gradient.
  /// When null, falls back to the picker's effective background color, then
  /// [ThemeData.scaffoldBackgroundColor].
  final Color? categoryFadeColor;

  /// Whether horizontal swipes on the icon grid change the active category.
  /// Defaults to `true`.
  final bool? swipeCategoryOnGrid;

  /// Minimum horizontal velocity (logical px/s) for a swipe on the icon grid
  /// to trigger a category change. Defaults to `300.0`.
  final double? swipeVelocityThreshold;

  const ElkIconPickerThemeData({
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
    this.selectedIconColor,
    this.borderRadius,
    this.searchStyle,
    this.searchHintStyle,
    this.tabLabelStyle,
    this.titleStyle,
    this.emptyStateStyle,
    this.iconStrokeWidth,
    this.iconRounded,
    this.iconSize,
    this.showSearch,
    this.showCategories,
    this.categoryStyle,
    this.allowUserToggleCategories,
    this.crossAxisCount,
    this.allowedCategoryIds,
    this.categoryIconSize,
    this.categoryTextSpacing,
    this.gridPadding,
    this.maxCrossAxisExtent,
    this.searchBarFillColor,
    this.sheetHandleColor,
    this.sheetTitleBarColor,
    this.tabIndicatorColor,
    this.categoryTabWidth,
    this.showCategoryFade,
    this.categoryFadeColor,
    this.swipeCategoryOnGrid,
    this.swipeVelocityThreshold,
  });

  @override
  ElkIconPickerThemeData copyWith({
    Color? backgroundColor,
    Color? iconColor,
    Color? selectedColor,
    Color? selectedIconColor,
    double? borderRadius,
    TextStyle? searchStyle,
    TextStyle? searchHintStyle,
    TextStyle? tabLabelStyle,
    TextStyle? titleStyle,
    TextStyle? emptyStateStyle,
    double? iconStrokeWidth,
    bool? iconRounded,
    double? iconSize,
    bool? showSearch,
    bool? showCategories,
    CategoryStyle? categoryStyle,
    bool? allowUserToggleCategories,
    int? crossAxisCount,
    List<String>? allowedCategoryIds,
    double? categoryIconSize,
    double? categoryTextSpacing,
    EdgeInsetsGeometry? gridPadding,
    double? maxCrossAxisExtent,
    Color? searchBarFillColor,
    Color? sheetHandleColor,
    Color? sheetTitleBarColor,
    Color? tabIndicatorColor,
    double? categoryTabWidth,
    bool? showCategoryFade,
    Color? categoryFadeColor,
    bool? swipeCategoryOnGrid,
    double? swipeVelocityThreshold,
  }) {
    return ElkIconPickerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      searchStyle: searchStyle ?? this.searchStyle,
      searchHintStyle: searchHintStyle ?? this.searchHintStyle,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      emptyStateStyle: emptyStateStyle ?? this.emptyStateStyle,
      iconStrokeWidth: iconStrokeWidth ?? this.iconStrokeWidth,
      iconRounded: iconRounded ?? this.iconRounded,
      iconSize: iconSize ?? this.iconSize,
      showSearch: showSearch ?? this.showSearch,
      showCategories: showCategories ?? this.showCategories,
      categoryStyle: categoryStyle ?? this.categoryStyle,
      allowUserToggleCategories:
          allowUserToggleCategories ?? this.allowUserToggleCategories,
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
      allowedCategoryIds: allowedCategoryIds ?? this.allowedCategoryIds,
      categoryIconSize: categoryIconSize ?? this.categoryIconSize,
      categoryTextSpacing: categoryTextSpacing ?? this.categoryTextSpacing,
      gridPadding: gridPadding ?? this.gridPadding,
      maxCrossAxisExtent: maxCrossAxisExtent ?? this.maxCrossAxisExtent,
      searchBarFillColor: searchBarFillColor ?? this.searchBarFillColor,
      sheetHandleColor: sheetHandleColor ?? this.sheetHandleColor,
      sheetTitleBarColor: sheetTitleBarColor ?? this.sheetTitleBarColor,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      categoryTabWidth: categoryTabWidth ?? this.categoryTabWidth,
      showCategoryFade: showCategoryFade ?? this.showCategoryFade,
      categoryFadeColor: categoryFadeColor ?? this.categoryFadeColor,
      swipeCategoryOnGrid: swipeCategoryOnGrid ?? this.swipeCategoryOnGrid,
      swipeVelocityThreshold:
          swipeVelocityThreshold ?? this.swipeVelocityThreshold,
    );
  }

  @override
  ElkIconPickerThemeData lerp(ElkIconPickerThemeData? other, double t) {
    if (other == null) return this;
    return ElkIconPickerThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      selectedIconColor: Color.lerp(
        selectedIconColor,
        other.selectedIconColor,
        t,
      ),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      searchStyle: TextStyle.lerp(searchStyle, other.searchStyle, t),
      searchHintStyle: TextStyle.lerp(
        searchHintStyle,
        other.searchHintStyle,
        t,
      ),
      tabLabelStyle: TextStyle.lerp(tabLabelStyle, other.tabLabelStyle, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      emptyStateStyle: TextStyle.lerp(
        emptyStateStyle,
        other.emptyStateStyle,
        t,
      ),
      iconStrokeWidth: lerpDouble(iconStrokeWidth, other.iconStrokeWidth, t),
      iconRounded: t < 0.5 ? iconRounded : other.iconRounded,
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      // Booleans snap at midpoint — standard Flutter convention
      showSearch: t < 0.5 ? showSearch : other.showSearch,
      showCategories: t < 0.5 ? showCategories : other.showCategories,
      categoryStyle: t < 0.5 ? categoryStyle : other.categoryStyle,
      allowUserToggleCategories: t < 0.5
          ? allowUserToggleCategories
          : other.allowUserToggleCategories,
      crossAxisCount: t < 0.5 ? crossAxisCount : other.crossAxisCount,
      allowedCategoryIds: t < 0.5
          ? allowedCategoryIds
          : other.allowedCategoryIds,
      categoryIconSize: lerpDouble(categoryIconSize, other.categoryIconSize, t),
      categoryTextSpacing: lerpDouble(
        categoryTextSpacing,
        other.categoryTextSpacing,
        t,
      ),
      gridPadding: EdgeInsetsGeometry.lerp(gridPadding, other.gridPadding, t),
      maxCrossAxisExtent: lerpDouble(
        maxCrossAxisExtent,
        other.maxCrossAxisExtent,
        t,
      ),
      searchBarFillColor: Color.lerp(
        searchBarFillColor,
        other.searchBarFillColor,
        t,
      ),
      sheetHandleColor: Color.lerp(sheetHandleColor, other.sheetHandleColor, t),
      sheetTitleBarColor: Color.lerp(
        sheetTitleBarColor,
        other.sheetTitleBarColor,
        t,
      ),
      tabIndicatorColor: Color.lerp(
        tabIndicatorColor,
        other.tabIndicatorColor,
        t,
      ),
      categoryTabWidth: lerpDouble(categoryTabWidth, other.categoryTabWidth, t),
      showCategoryFade: t < 0.5 ? showCategoryFade : other.showCategoryFade,
      categoryFadeColor: Color.lerp(
        categoryFadeColor,
        other.categoryFadeColor,
        t,
      ),
      swipeCategoryOnGrid: t < 0.5
          ? swipeCategoryOnGrid
          : other.swipeCategoryOnGrid,
      swipeVelocityThreshold: lerpDouble(
        swipeVelocityThreshold,
        other.swipeVelocityThreshold,
        t,
      ),
    );
  }
}

/// Linearly interpolates between two doubles, handling nulls gracefully.
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  return (a ?? b)! + ((b ?? a)! - (a ?? b)!) * t;
}
