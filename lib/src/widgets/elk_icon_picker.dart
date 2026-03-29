import 'package:flutter/material.dart';
import '../gen/lucide_icons.g.dart';
import '../models/icon_source.dart';
import '../models/lucide_category.dart';
import '../services/icon_search_service.dart';
import 'lucide_icon.dart';

/// A customizable, inline Lucide icon picker widget.
class ElkIconPicker extends StatefulWidget {
  /// Callback when an icon is selected.
  final void Function(IconSelection selection) onSelected;

  /// The currently selected icon data to highlight.
  final IconSelection? currentSelection;

  /// The number of icons across in the grid. Defaults to 5.
  final int crossAxisCount;

  /// The background color of the picker.
  final Color? backgroundColor;

  /// The color for unselected icons.
  final Color? iconColor;

  /// The color for the selected icon indicator.
  final Color? selectedColor;

  /// The radius of the rounded corners for selection indicators.
  final double borderRadius;

  /// Controller for the icon grid scroll.
  final ScrollController? scrollController;

  /// Whether to show the search bar. Defaults to true.
  final bool showSearch;

  /// Whether to show category tabs. Defaults to true.
  final bool showCategories;

  /// How to display the category tabs. Defaults to [CategoryStyle.both].
  final CategoryStyle categoryStyle;

  const ElkIconPicker({
    super.key,
    required this.onSelected,
    this.currentSelection,
    this.crossAxisCount = 5,
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
    this.borderRadius = 8.0,
    this.scrollController,
    this.showSearch = true,
    this.showCategories = true,
    this.categoryStyle = CategoryStyle.both,
  });

  @override
  State<ElkIconPicker> createState() => _ElkIconPickerState();
}

class _ElkIconPickerState extends State<ElkIconPicker>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TabController? _tabController;

  // We add an "All" category at index 0.
  static const _allCategory = LucideCategory(
    id: 'all',
    title: 'All',
    representativeIcon: LucideIcons.layoutGrid,
  );

  List<LucideCategory> get _categories => [_allCategory, ...kLucideCategories];

  @override
  void initState() {
    super.initState();
    if (widget.showCategories) {
      _tabController = TabController(length: _categories.length, vsync: this);
      _tabController?.addListener(() => setState(() {}));
    }
  }

  @override
  void didUpdateWidget(ElkIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCategories != oldWidget.showCategories) {
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
    final selectedColor = widget.selectedColor ?? theme.colorScheme.primary;
    final iconColor = widget.iconColor ?? theme.iconTheme.color ?? Colors.black54;

    final currentCategory = (_tabController != null && widget.showCategories)
        ? _categories[_tabController!.index]
        : _allCategory;

    final filteredIcons = IconSearchService.filter(
      _searchQuery,
      categoryId: currentCategory.id == 'all' ? null : currentCategory.id,
    );

    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [
          // Search bar
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search icons...',
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
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

          // Categories
          if (widget.showCategories && _tabController != null)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
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
                        LucideIcon(cat.representativeIcon, size: 16),
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
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No icons found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey),
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
                      final isSelected = widget.currentSelection is LucideIconSelection &&
                          (widget.currentSelection as LucideIconSelection).data == iconData;

                      return InkWell(
                        onTap: () => widget.onSelected(LucideIconSelection(iconData)),
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? selectedColor.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            border: isSelected
                                ? Border.all(color: selectedColor, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: LucideIcon(
                              iconData,
                              size: 28,
                              color: isSelected ? selectedColor : iconColor,
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
