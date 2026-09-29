import '../gen/lucide_icons.g.dart';
import '../models/lucide_icon_data.dart';

/// Service for searching and filtering the Lucide icon set.
class IconSearchService {
  IconSearchService._();

  static final Map<String, LucideIconData> _byName = {
    for (final icon in kLucideIcons) icon.name: icon,
  };

  /// Looks up an icon by its kebab-case Lucide name (e.g. `'circle-check'`).
  ///
  /// Names Lucide has since renamed (e.g. `'smile'`, now
  /// `'face-slightly-smiling'`) resolve to the current icon via
  /// [kLucideIconAliases], so icon names saved by the host app keep working
  /// across icon set updates. Returns `null` for a `null` or unknown name,
  /// so a stored optional name can be looked up directly with a fallback:
  /// `IconSearchService.findByName(savedName) ?? LucideIcons.circleCheck`.
  static LucideIconData? findByName(String? name) {
    if (name == null) return null;
    return _byName[name] ?? _byName[kLucideIconAliases[name]];
  }

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
