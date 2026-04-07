import 'package:flutter/material.dart';
import '../gen/lucide_icons.g.dart';
import '../models/icon_source.dart';
import '../models/lucide_category.dart';
import '../services/icon_search_service.dart';
import 'elk_icon_picker_theme.dart';
import 'lucide_icon.dart';

/// A customizable, inline Lucide icon picker widget.
///
/// Visual appearance is resolved in this priority order:
///   1. Explicit constructor param (highest)
///   2. [ElkIconPickerThemeData] from the ambient [ThemeData.extensions]
///   3. Material 3 [ColorScheme] / [TextTheme] fallback (lowest)
class ElkIconPicker extends StatefulWidget {
  /// Callback when an icon is selected.
  final void Function(IconSelection selection) onSelected;

  /// The currently selected icon data to highlight.
  final IconSelection? currentSelection;

  /// The number of icons across in the grid. Defaults to 5.
  final int crossAxisCount;

  /// The background color of the picker. Overrides [ElkIconPickerThemeData.backgroundColor].
  final Color? backgroundColor;

  /// The color for unselected icons. Overrides [ElkIconPickerThemeData.iconColor].
  final Color? iconColor;

  /// The color for the selected icon indicator. Overrides [ElkIconPickerThemeData.selectedColor].
  final Color? selectedColor;

  /// The radius of the rounded corners for selection indicators.
  /// Overrides [ElkIconPickerThemeData.borderRadius].
  final double? borderRadius;

  /// Stroke width for icon rendering. Overrides [ElkIconPickerThemeData.iconStrokeWidth].
  final double? iconStrokeWidth;

  /// Whether icons use rounded stroke caps and joins.
  /// Overrides [ElkIconPickerThemeData.iconRounded].
  final bool? iconRounded;

  /// Controller for the icon grid scroll.
  final ScrollController? scrollController;

  /// Whether to show the search bar. Defaults to true.
  final bool showSearch;

  /// Whether to show category tabs. Defaults to true.
  final bool showCategories;

  /// How to display the category tabs. Defaults to [CategoryStyle.both].
  final CategoryStyle categoryStyle;

  /// Limits which categories appear in the tab bar.
  ///
  /// Pass a list of category IDs (e.g. `['arrows', 'shapes', 'devices']`) to
  /// show only those categories. The "All" tab is always included.
  /// If null or empty, all categories are shown.
  final List<String>? allowedCategoryIds;

  /// When true, a toggle button is shown in the search bar row that lets the
  /// end user show or hide the category tabs at runtime.
  ///
  /// Defaults to false. Requires [showCategories] to be true to have any effect.
  final bool allowUserToggleCategories;

  const ElkIconPicker({
    super.key,
    required this.onSelected,
    this.currentSelection,
    this.crossAxisCount = 5,
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
    this.borderRadius,
    this.iconStrokeWidth,
    this.iconRounded,
    this.scrollController,
    this.showSearch = true,
    this.showCategories = true,
    this.categoryStyle = CategoryStyle.both,
    this.allowedCategoryIds,
    this.allowUserToggleCategories = false,
  });

  @override
  State<ElkIconPicker> createState() => _ElkIconPickerState();
}

class _ElkIconPickerState extends State<ElkIconPicker>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TabController? _tabController;
  late bool _categoriesVisible;

  // We add an "All" category at index 0.
  static const _allCategory = LucideCategory(
    id: 'all',
    title: 'All',
    representativeIcon: LucideIcons.layoutGrid,
  );

  List<LucideCategory> get _categories {
    final allowed = widget.allowedCategoryIds;
    final filtered = (allowed == null || allowed.isEmpty)
        ? kLucideCategories
        : kLucideCategories.where((c) => allowed.contains(c.id)).toList();
    return [_allCategory, ...filtered];
  }

  @override
  void initState() {
    super.initState();
    _categoriesVisible = widget.showCategories;
    if (widget.showCategories) {
      _tabController = TabController(length: _categories.length, vsync: this);
      _tabController?.addListener(() => setState(() {}));
    }
  }

  @override
  void didUpdateWidget(ElkIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final categoriesChanged =
        widget.showCategories != oldWidget.showCategories ||
        widget.allowedCategoryIds != oldWidget.allowedCategoryIds;
    if (categoriesChanged) {
      _tabController?.dispose();
      if (widget.showCategories) {
        _tabController = TabController(length: _categories.length, vsync: this);
        _tabController?.addListener(() => setState(() {}));
      } else {
        _tabController = null;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ElkIconPickerThemeData>();

    // Resolve values: explicit param > theme extension > M3 fallback
    final resolvedBg = widget.backgroundColor ?? ext?.backgroundColor;
    final resolvedIconColor =
        widget.iconColor ?? ext?.iconColor ?? theme.iconTheme.color ?? Colors.black54;
    final resolvedSelectedColor =
        widget.selectedColor ?? ext?.selectedColor ?? theme.colorScheme.primary;
    final resolvedBorderRadius = widget.borderRadius ?? ext?.borderRadius ?? 8.0;
    final resolvedStrokeWidth = widget.iconStrokeWidth ?? ext?.iconStrokeWidth ?? 2.0;
    final resolvedRounded = widget.iconRounded ?? ext?.iconRounded ?? true;

    final currentCategory = (_tabController != null && _categoriesVisible)
        ? _categories[_tabController!.index]
        : _allCategory;

    final filteredIcons = IconSearchService.filter(
      _searchQuery,
      categoryId: currentCategory.id == 'all' ? null : currentCategory.id,
    );

    return Container(
      color: resolvedBg,
      child: Column(
        children: [
          // Search bar
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: ext?.searchStyle,
                      decoration: InputDecoration(
                        hintText: 'Search icons...',
                        hintStyle: ext?.searchHintStyle,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(resolvedBorderRadius),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                  if (widget.allowUserToggleCategories && widget.showCategories) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _categoriesVisible
                          ? 'Hide categories'
                          : 'Show categories',
                      icon: Icon(
                        _categoriesVisible
                            ? Icons.label_off_outlined
                            : Icons.label_outline,
                      ),
                      onPressed: () =>
                          setState(() => _categoriesVisible = !_categoriesVisible),
                    ),
                  ],
                ],
              ),
            ),

          // Categories
          if (_categoriesVisible && _tabController != null)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: ext?.tabLabelStyle,
              tabs: _categories.map((cat) {
                final showIcon = widget.categoryStyle == CategoryStyle.both ||
                    widget.categoryStyle == CategoryStyle.iconsOnly;
                final showText = widget.categoryStyle == CategoryStyle.both ||
                    widget.categoryStyle == CategoryStyle.textOnly;

                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showIcon) ...[
                        LucideIcon(
                          cat.representativeIcon,
                          size: 16,
                          strokeWidth: resolvedStrokeWidth,
                          rounded: resolvedRounded,
                        ),
                        if (showText) const SizedBox(width: 8),
                      ],
                      if (showText) Text(cat.title),
                    ],
                  ),
                );
              }).toList(),
            ),

          // Icon Grid
          Expanded(
            child: filteredIcons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: (ext?.emptyStateStyle?.color) ?? Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No icons found for "$_searchQuery"',
                          style: ext?.emptyStateStyle ??
                              const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.crossAxisCount,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: filteredIcons.length,
                    itemBuilder: (context, index) {
                      final iconData = filteredIcons[index];
                      final isSelected =
                          widget.currentSelection is LucideIconSelection &&
                              (widget.currentSelection as LucideIconSelection)
                                      .data ==
                                  iconData;

                      return InkWell(
                        onTap: () => widget.onSelected(LucideIconSelection(iconData)),
                        borderRadius: BorderRadius.circular(resolvedBorderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? resolvedSelectedColor.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(resolvedBorderRadius),
                            border: isSelected
                                ? Border.all(color: resolvedSelectedColor, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: LucideIcon(
                              iconData,
                              size: 28,
                              color: isSelected
                                  ? resolvedSelectedColor
                                  : resolvedIconColor,
                              strokeWidth: resolvedStrokeWidth,
                              rounded: resolvedRounded,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
