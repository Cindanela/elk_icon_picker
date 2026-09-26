import 'package:flutter_test/flutter_test.dart';
import 'package:elk_icon_picker/src/services/icon_search_service.dart';
import 'package:elk_icon_picker/src/gen/lucide_icons.g.dart';

void main() {
  group('IconSearchService', () {
    test('filter returns all icons when query is empty', () {
      final results = IconSearchService.filter('');

      expect(results.length, kLucideIcons.length);
      expect(results, equals(kLucideIcons));
    });

    test('filter returns all icons when query contains only whitespaces', () {
      final results = IconSearchService.filter('   ');

      expect(results.length, kLucideIcons.length);
      expect(results, equals(kLucideIcons));
    });

    test('filter returns correct category icons when query is empty and categoryId is provided', () {
      // Find a category that actually exists in the generated data
      final categorySet = kLucideIcons.expand((icon) => icon.categories).toSet();
      if (categorySet.isNotEmpty) {
        final categoryId = categorySet.first;

        final expectedCount = kLucideIcons.where((icon) => icon.categories.contains(categoryId)).length;

        final results = IconSearchService.filter('', categoryId: categoryId);

        expect(results.length, expectedCount);
        expect(
          results.every((icon) => icon.categories.contains(categoryId)),
          isTrue,
        );
      }
    });
  });
}
