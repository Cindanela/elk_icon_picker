import '../gen/lucide_icons.g.dart';
import '../models/lucide_icon_data.dart';

/// Service for searching and filtering the Lucide icon set.
class IconSearchService {
  IconSearchService._();

  /// Filters icons based on a query string and/or a category ID.
  ///
  /// The [query] is compared against icon names and tags (case-insensitive).
  /// If [categoryId] is provided, only icons belonging to that category are returned.
  static List<LucideIconData> filter(String query, {String? categoryId}) {
    final lowerQuery = query.toLowerCase().trim();

    return kLucideIcons.where((icon) {
      // Category filter
      if (categoryId != null && !icon.categories.contains(categoryId)) {
        return false;
      }

      // Query filter
      if (lowerQuery.isEmpty) return true;

      // Match name
      if (icon.name.toLowerCase().contains(lowerQuery)) return true;

      // Match tags
      for (final tag in icon.tags) {
        if (tag.toLowerCase().contains(lowerQuery)) return true;
      }

      return false;
    }).toList();
  }
}
