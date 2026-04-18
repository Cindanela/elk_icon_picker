import 'package:flutter/material.dart';
import '../models/icon_source.dart';
import '../models/lucide_category.dart';
import 'elk_icon_picker.dart';
import 'elk_icon_picker_theme.dart';

/// Shows a Lucide icon picker in a modal bottom sheet.
///
/// Returns the selected [IconSelection] or null if the sheet was dismissed.
///
/// Visual appearance is resolved in this priority order:
///   1. Explicit parameter (highest)
///   2. [ElkIconPickerThemeData] from the ambient [ThemeData.extensions]
///   3. Material 3 [ColorScheme] fallback (lowest)
Future<IconSelection?> showElkIconPicker(
  BuildContext context, {
  IconSelection? currentSelection,
  Color? backgroundColor,
  Color? iconColor,
  Color? selectedColor,
  Color? selectedIconColor,
  double? borderRadius,
  double? iconStrokeWidth,
  bool? iconRounded,
  double? iconSize,
  Color? searchBarFillColor,
  Color? tabIndicatorColor,
  int? crossAxisCount,
  void Function(IconSelection)? onSelected,
  bool? showSearch,
  bool? showCategories,
  CategoryStyle? categoryStyle,
  List<String>? allowedCategoryIds,
  bool? allowUserToggleCategories,
  double? categoryTabWidth,
  bool? showCategoryFade,
  Color? categoryFadeColor,
  bool? swipeCategoryOnGrid,
  double? swipeVelocityThreshold,
}) {
  final ext = Theme.of(context).extension<ElkIconPickerThemeData>();

  final resolvedBg =
      backgroundColor ??
      ext?.backgroundColor ??
      Theme.of(context).scaffoldBackgroundColor;
  final resolvedBorderRadius = borderRadius ?? ext?.borderRadius ?? 12.0;

  return showModalBottomSheet<IconSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        final sheetExt = Theme.of(context).extension<ElkIconPickerThemeData>();

        final resolvedHandleColor =
            sheetExt?.sheetHandleColor ?? Colors.grey.withValues(alpha: 0.3);

        return Container(
          decoration: BoxDecoration(
            color: resolvedBg,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(resolvedBorderRadius),
            ),
          ),
          child: Column(
            children: [
              // Title bar area (handle + title) with optional background tint
              Container(
                color: sheetExt?.sheetTitleBarColor,
                child: Column(
                  children: [
                    // Pull handle
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: resolvedHandleColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        'Select Icon',
                        style:
                            sheetExt?.titleStyle ??
                            const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // The Picker
              Expanded(
                child: ElkIconPicker(
                  scrollController: scrollController,
                  currentSelection: currentSelection,
                  onSelected: (selection) {
                    onSelected?.call(selection);
                    Navigator.pop(context, selection);
                  },
                  crossAxisCount: crossAxisCount,
                  iconColor: iconColor,
                  selectedColor: selectedColor,
                  selectedIconColor: selectedIconColor,
                  borderRadius: borderRadius,
                  iconStrokeWidth: iconStrokeWidth,
                  iconRounded: iconRounded,
                  iconSize: iconSize,
                  searchBarFillColor: searchBarFillColor,
                  tabIndicatorColor: tabIndicatorColor,
                  showSearch: showSearch,
                  showCategories: showCategories,
                  categoryStyle: categoryStyle,
                  allowedCategoryIds: allowedCategoryIds,
                  allowUserToggleCategories: allowUserToggleCategories,
                  categoryTabWidth: categoryTabWidth,
                  showCategoryFade: showCategoryFade,
                  categoryFadeColor: categoryFadeColor,
                  swipeCategoryOnGrid: swipeCategoryOnGrid,
                  swipeVelocityThreshold: swipeVelocityThreshold,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
