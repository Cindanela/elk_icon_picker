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

  /// The number of icons across in the grid.
  ///
  /// When null, the count is calculated adaptively from the screen width,
  /// targeting ~64 dp per cell and clamped between 4 and 10.
  /// Overrides [ElkIconPickerThemeData] adaptive behaviour when set.
  final int? crossAxisCount;

  /// The background color of the picker. Overrides [ElkIconPickerThemeData.backgroundColor].
  final Color? backgroundColor;

  /// The color for unselected icons. Overrides [ElkIconPickerThemeData.iconColor].
  final Color? iconColor;

  /// The color for the selected icon indicator. Overrides [ElkIconPickerThemeData.selectedColor].
  final Color? selectedColor;

  /// The color of the icon stroke itself when selected.
  /// Overrides [ElkIconPickerThemeData.selectedIconColor].
  final Color? selectedIconColor;

  /// The radius of the rounded corners for selection indicators.
  /// Overrides [ElkIconPickerThemeData.borderRadius].
  final double? borderRadius;

  /// Stroke width for icon rendering. Overrides [ElkIconPickerThemeData.iconStrokeWidth].
  final double? iconStrokeWidth;

  /// Whether icons use rounded stroke caps and joins.
  /// Overrides [ElkIconPickerThemeData.iconRounded].
  final bool? iconRounded;

  /// Rendered size of each icon in the grid.
  /// Overrides [ElkIconPickerThemeData.iconSize]. Defaults to `24.0`.
  final double? iconSize;

  /// Fill color of the search input field.
  /// Overrides [ElkIconPickerThemeData.searchBarFillColor].
  final Color? searchBarFillColor;

  /// Color of the selected tab underline/indicator.
  /// Overrides [ElkIconPickerThemeData.tabIndicatorColor].
  final Color? tabIndicatorColor;

  /// Controller for the icon grid scroll.
  final ScrollController? scrollController;

  /// Whether to show the search bar.
  /// Overrides [ElkIconPickerThemeData.showSearch]. Defaults to `true`.
  final bool? showSearch;

  /// Whether to show category tabs.
  /// Overrides [ElkIconPickerThemeData.showCategories]. Defaults to `true`.
  final bool? showCategories;

  /// How to display the category tabs.
  /// Overrides [ElkIconPickerThemeData.categoryStyle]. Defaults to [CategoryStyle.both].
  final CategoryStyle? categoryStyle;

  /// Limits which categories appear in the tab bar.
  ///
  /// Pass a list of category IDs (e.g. `['arrows', 'shapes', 'devices']`) to
  /// show only those categories. The "All" tab is always included.
  /// If null or empty, all categories are shown.
  final List<String>? allowedCategoryIds;

  /// When true, a toggle button is shown in the search bar row that lets the
  /// end user show or hide the category tabs at runtime.
  ///
  /// Overrides [ElkIconPickerThemeData.allowUserToggleCategories]. Defaults to `false`.
  final bool? allowUserToggleCategories;

  /// Rendered size of icons in the category tab bar.
  /// Overrides [ElkIconPickerThemeData.categoryIconSize]. Defaults to `18.0`.
  final double? categoryIconSize;

  /// Spacing between the icon and text in a category tab.
  /// Overrides [ElkIconPickerThemeData.categoryTextSpacing]. Defaults to `8.0`.
  final double? categoryTextSpacing;

  /// Padding around the main icon grid.
  /// Overrides [ElkIconPickerThemeData.gridPadding]. Defaults to `EdgeInsets.all(16.0)`.
  final EdgeInsetsGeometry? gridPadding;

  /// Fixed width for each category tab.
  /// Overrides [ElkIconPickerThemeData.categoryTabWidth].
  final double? categoryTabWidth;

  /// Whether to show gradient fade overlays at the edges of the category tab bar.
  /// Overrides [ElkIconPickerThemeData.showCategoryFade]. Defaults to `true`.
  final bool? showCategoryFade;

  /// Color of the category tab bar edge fade gradient.
  /// Overrides [ElkIconPickerThemeData.categoryFadeColor].
  final Color? categoryFadeColor;

  /// Whether horizontal swipes on the icon grid change the active category.
  /// Overrides [ElkIconPickerThemeData.swipeCategoryOnGrid]. Defaults to `true`.
  final bool? swipeCategoryOnGrid;

  /// Minimum horizontal velocity (logical px/s) for a swipe to trigger a
  /// category change. Overrides [ElkIconPickerThemeData.swipeVelocityThreshold].
  /// Defaults to `300.0`.
  final double? swipeVelocityThreshold;

  const ElkIconPicker({
    super.key,
    required this.onSelected,
    this.currentSelection,
    this.crossAxisCount,
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
    this.selectedIconColor,
    this.borderRadius,
    this.iconStrokeWidth,
    this.iconRounded,
    this.iconSize,
    this.searchBarFillColor,
    this.tabIndicatorColor,
    this.scrollController,
    this.showSearch,
    this.showCategories,
    this.categoryStyle,
    this.allowedCategoryIds,
    this.allowUserToggleCategories,
    this.categoryIconSize,
    this.categoryTextSpacing,
    this.gridPadding,
    this.categoryTabWidth,
    this.showCategoryFade,
    this.categoryFadeColor,
    this.swipeCategoryOnGrid,
    this.swipeVelocityThreshold,
  });

  @override
  State<ElkIconPicker> createState() => _ElkIconPickerState();
}

class _ElkIconPickerState extends State<ElkIconPicker>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TabController? _tabController;
  late bool _categoriesVisible;
  double _tabBarScrollOffset = 0.0;
  // Start > 0 so the right fade shows on first build before scroll metrics arrive.
  double _tabBarMaxScrollExtent = 1.0;

  // We add an "All" category at index 0.
  static const _allCategory = LucideCategory(
    id: 'all',
    title: 'All',
    representativeIcon: LucideIcons.layoutGrid,
  );

  List<LucideCategory> get _categories {
    final theme = Theme.of(context);
    final ext = theme.extension<ElkIconPickerThemeData>();
    final allowed = widget.allowedCategoryIds ?? ext?.allowedCategoryIds;

    final filtered = (allowed == null || allowed.isEmpty)
        ? kLucideCategories
        : kLucideCategories.where((c) => allowed.contains(c.id)).toList();
    return [_allCategory, ...filtered];
  }

  @override
  void initState() {
    super.initState();
    // We CANNOT initialize _tabController here because its length depends on
    // Theme.of(context) via the _categories getter.
    // didChangeDependencies will handle the initial creation.
    _categoriesVisible = widget.showCategories ?? true;
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bool needsRecreate = false;

    // Resolve the visibility from the theme when widget param is null.
    if (widget.showCategories == null) {
      final ext = Theme.of(context).extension<ElkIconPickerThemeData>();
      final themeShow = ext?.showCategories ?? true;
      if (_categoriesVisible != themeShow) {
        _categoriesVisible = themeShow;
        needsRecreate = true;
      }
    }

    // Initialize the controller if it doesn't exist yet but categories are visible.
    if (_categoriesVisible && _tabController == null) {
      needsRecreate = true;
    }

    if (needsRecreate) {
      _recreateTabController();
    }
  }

  @override
  void didUpdateWidget(ElkIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final categoriesChanged =
        widget.showCategories != oldWidget.showCategories ||
        widget.allowedCategoryIds != oldWidget.allowedCategoryIds;
    if (categoriesChanged) {
      _categoriesVisible = widget.showCategories ?? _categoriesVisible;
      _recreateTabController();
    }
  }

  void _recreateTabController() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    _tabBarScrollOffset = 0.0;
    _tabBarMaxScrollExtent = 1.0;
    if (_categoriesVisible) {
      _tabController = TabController(length: _categories.length, vsync: this);
      _tabController?.addListener(_handleTabChange);
    } else {
      _tabController = null;
    }
    if (mounted) setState(() {});
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
        widget.iconColor ??
        ext?.iconColor ??
        theme.iconTheme.color ??
        Colors.black54;
    final resolvedSelectedColor =
        widget.selectedColor ?? ext?.selectedColor ?? theme.colorScheme.primary;
    final resolvedSelectedIconColor =
        widget.selectedIconColor ??
        ext?.selectedIconColor ??
        resolvedSelectedColor;
    final resolvedBorderRadius =
        widget.borderRadius ?? ext?.borderRadius ?? 8.0;
    final resolvedStrokeWidth =
        widget.iconStrokeWidth ?? ext?.iconStrokeWidth ?? 2.0;
    final resolvedRounded = widget.iconRounded ?? ext?.iconRounded ?? true;
    final resolvedIconSize = widget.iconSize ?? ext?.iconSize ?? 24.0;
    final resolvedSearchBarFillColor =
        widget.searchBarFillColor ?? ext?.searchBarFillColor;
    final resolvedTabIndicatorColor =
        widget.tabIndicatorColor ?? ext?.tabIndicatorColor;
    final resolvedShowSearch = widget.showSearch ?? ext?.showSearch ?? true;
    final resolvedShowCategories =
        widget.showCategories ?? ext?.showCategories ?? true;
    final resolvedCategoryStyle =
        widget.categoryStyle ?? ext?.categoryStyle ?? CategoryStyle.both;
    final resolvedAllowUserToggle =
        widget.allowUserToggleCategories ??
        ext?.allowUserToggleCategories ??
        false;

    // Grid layout: fixed columns vs fluid/adaptive extent
    final gridDelegate =
        (widget.crossAxisCount != null || ext?.crossAxisCount != null)
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount ?? ext!.crossAxisCount!,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          )
        : SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent:
                ext?.maxCrossAxisExtent ?? (resolvedIconSize * 2.5),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          );

    final resolvedCategoryIconSize =
        widget.categoryIconSize ?? ext?.categoryIconSize ?? 18.0;
    final resolvedCategoryTextSpacing =
        widget.categoryTextSpacing ?? ext?.categoryTextSpacing ?? 8.0;
    final resolvedGridPadding =
        widget.gridPadding ?? ext?.gridPadding ?? const EdgeInsets.all(16.0);

    final resolvedCategoryTabWidth =
        widget.categoryTabWidth ?? ext?.categoryTabWidth;
    final resolvedShowFade =
        widget.showCategoryFade ?? ext?.showCategoryFade ?? true;
    final resolvedFadeColor =
        widget.categoryFadeColor ??
        ext?.categoryFadeColor ??
        resolvedBg ??
        theme.scaffoldBackgroundColor;
    final resolvedSwipeOnGrid =
        widget.swipeCategoryOnGrid ?? ext?.swipeCategoryOnGrid ?? true;
    final resolvedSwipeThreshold =
        widget.swipeVelocityThreshold ?? ext?.swipeVelocityThreshold ?? 300.0;

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
          if (resolvedShowSearch)
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
                        filled: resolvedSearchBarFillColor != null,
                        fillColor: resolvedSearchBarFillColor,
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
                          borderRadius: BorderRadius.circular(
                            resolvedBorderRadius,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ),
                  if (resolvedAllowUserToggle && resolvedShowCategories) ...[
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
                      onPressed: () => setState(
                        () => _categoriesVisible = !_categoriesVisible,
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Categories
          if (_categoriesVisible && _tabController != null)
            Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    final px = notification.metrics.pixels;
                    final mx = notification.metrics.maxScrollExtent;
                    if (px != _tabBarScrollOffset ||
                        mx != _tabBarMaxScrollExtent) {
                      setState(() {
                        _tabBarScrollOffset = px;
                        _tabBarMaxScrollExtent = mx;
                      });
                    }
                    return false;
                  },
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle: ext?.tabLabelStyle,
                    indicatorColor: resolvedTabIndicatorColor,
                    tabs: _categories.map((cat) {
                      final showIcon =
                          resolvedCategoryStyle == CategoryStyle.both ||
                          resolvedCategoryStyle == CategoryStyle.iconsOnly;
                      final showText =
                          resolvedCategoryStyle == CategoryStyle.both ||
                          resolvedCategoryStyle == CategoryStyle.textOnly;
                      final isSelected =
                          _tabController?.index == _categories.indexOf(cat);

                      final tabContent = Row(
                        mainAxisSize: resolvedCategoryTabWidth != null
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (showIcon) ...[
                            LucideIcon(
                              cat.representativeIcon,
                              size: resolvedCategoryIconSize,
                              color: isSelected
                                  ? resolvedSelectedColor
                                  : resolvedIconColor,
                              strokeWidth: resolvedStrokeWidth,
                              rounded: resolvedRounded,
                            ),
                          ],
                          if (showIcon && showText)
                            SizedBox(width: resolvedCategoryTextSpacing),
                          if (showText) Text(cat.title),
                        ],
                      );

                      return Tab(
                        child: resolvedCategoryTabWidth != null
                            ? SizedBox(
                                width: resolvedCategoryTabWidth,
                                child: tabContent,
                              )
                            : tabContent,
                      );
                    }).toList(),
                  ),
                ),

                // Left fade — visible once the tab bar has been scrolled right
                if (resolvedShowFade && _tabBarScrollOffset > 0)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: 32,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              resolvedFadeColor,
                              resolvedFadeColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Right fade — visible when more tabs exist beyond the viewport
                if (resolvedShowFade &&
                    _tabBarMaxScrollExtent > 0 &&
                    _tabBarScrollOffset < _tabBarMaxScrollExtent)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: 32,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              resolvedFadeColor,
                              resolvedFadeColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
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
                          style:
                              ext?.emptyStateStyle ??
                              const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _buildSwipeableGrid(
                    resolvedSwipeOnGrid: resolvedSwipeOnGrid,
                    resolvedSwipeThreshold: resolvedSwipeThreshold,
                    gridView: GridView.builder(
                      controller: widget.scrollController,
                      padding: resolvedGridPadding,
                      gridDelegate: gridDelegate,
                      itemCount: filteredIcons.length,
                      itemBuilder: (context, index) {
                        final iconData = filteredIcons[index];
                        final isSelected =
                            widget.currentSelection is LucideIconSelection &&
                            (widget.currentSelection as LucideIconSelection)
                                    .data ==
                                iconData;

                        return InkWell(
                          onTap: () =>
                              widget.onSelected(LucideIconSelection(iconData)),
                          borderRadius: BorderRadius.circular(
                            resolvedBorderRadius,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? resolvedSelectedColor.withValues(
                                      alpha: 0.12,
                                    )
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                resolvedBorderRadius,
                              ),
                              border: isSelected
                                  ? Border.all(
                                      color: resolvedSelectedColor,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: LucideIcon(
                                iconData,
                                size: resolvedIconSize,
                                color: isSelected
                                    ? resolvedSelectedIconColor
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
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableGrid({
    required Widget gridView,
    required bool resolvedSwipeOnGrid,
    required double resolvedSwipeThreshold,
  }) {
    if (!resolvedSwipeOnGrid || _tabController == null) return gridView;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0.0;
        if (v.abs() < resolvedSwipeThreshold) return;
        final idx = _tabController!.index;
        final max = _categories.length - 1;
        if (v < 0 && idx < max) _tabController!.animateTo(idx + 1);
        if (v > 0 && idx > 0) _tabController!.animateTo(idx - 1);
      },
      child: gridView,
    );
  }
}
