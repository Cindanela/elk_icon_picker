import 'package:flutter_test/flutter_test.dart';
import 'package:elk_icon_picker/src/models/icon_source.dart';
import 'package:elk_lucide_icons/elk_lucide_icons.dart';

void main() {
  group('IconSelection Equality', () {
    test('LucideIconSelection equality', () {
      const data1 = LucideIconData(name: 'activity', tags: [], categories: []);
      const data2 = LucideIconData(name: 'activity', tags: [], categories: []);
      const data3 = LucideIconData(name: 'anchor', tags: [], categories: []);

      const selection1 = LucideIconSelection(data1);
      const selection2 = LucideIconSelection(data2);
      const selection3 = LucideIconSelection(data3);

      expect(selection1, equals(selection1));
      expect(selection1, equals(selection2));
      expect(selection1, isNot(equals(selection3)));
      expect(selection1.hashCode, equals(selection2.hashCode));
    });

    test('EmojiSelection equality', () {
      const selection1 = EmojiSelection('👍');
      const selection2 = EmojiSelection('👍');
      const selection3 = EmojiSelection('👎');

      expect(selection1, equals(selection1));
      expect(selection1, equals(selection2));
      expect(selection1, isNot(equals(selection3)));
      expect(selection1.hashCode, equals(selection2.hashCode));
    });

    test('ImportedIconSelection equality', () {
      const selection1 = ImportedIconSelection(
        fontFamily: 'MaterialIcons',
        codepoint: 0xe000,
        name: 'alarm',
      );
      const selection2 = ImportedIconSelection(
        fontFamily: 'MaterialIcons',
        codepoint: 0xe000,
        name: 'alarm',
      );
      const selection3 = ImportedIconSelection(
        fontFamily: 'MaterialIcons',
        codepoint: 0xe001,
        name: 'alarm_add',
      );

      expect(selection1, equals(selection1));
      expect(selection1, equals(selection2));
      expect(selection1, isNot(equals(selection3)));
      expect(selection1.hashCode, equals(selection2.hashCode));
    });

    test('BundledIconSelection equality', () {
      const selection1 = BundledIconSelection('assets/icon1.svg');
      const selection2 = BundledIconSelection('assets/icon1.svg');
      const selection3 = BundledIconSelection('assets/icon2.svg');

      expect(selection1, equals(selection1));
      expect(selection1, equals(selection2));
      expect(selection1, isNot(equals(selection3)));
      expect(selection1.hashCode, equals(selection2.hashCode));
    });

    test('Different subclass inequality', () {
      const lucide = LucideIconSelection(LucideIconData(name: 'activity', tags: [], categories: []));
      const emoji = EmojiSelection('👍');
      const imported = ImportedIconSelection(fontFamily: 'M', codepoint: 1, name: 'n');
      const bundled = BundledIconSelection('a');

      expect(lucide, isNot(equals(emoji)));
      expect(lucide, isNot(equals(imported)));
      expect(lucide, isNot(equals(bundled)));
      expect(emoji, isNot(equals(imported)));
      expect(emoji, isNot(equals(bundled)));
      expect(imported, isNot(equals(bundled)));
    });
  });
}
