import 'package:flutter/foundation.dart';
import 'package:elk_lucide_icons/elk_lucide_icons.dart';

/// Base class for any icon/emote selection a user can make.
sealed class IconSelection {
  const IconSelection();
}

/// A Lucide icon from the built-in icon set.
@immutable
class LucideIconSelection extends IconSelection {
  final LucideIconData data;
  const LucideIconSelection(this.data);

  String get name => data.name;

  @override
  bool operator ==(Object other) =>
      other is LucideIconSelection && other.data == data;

  @override
  int get hashCode => data.hashCode;
}

/// An emoji character (reserved for future use).
@immutable
class EmojiSelection extends IconSelection {
  final String emoji;
  const EmojiSelection(this.emoji);

  @override
  bool operator ==(Object other) =>
      other is EmojiSelection && other.emoji == emoji;

  @override
  int get hashCode => emoji.hashCode;
}

/// A custom font icon provided by the host application.
@immutable
class ImportedIconSelection extends IconSelection {
  final String fontFamily;
  final int codepoint;
  final String name;
  const ImportedIconSelection({
    required this.fontFamily,
    required this.codepoint,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      other is ImportedIconSelection &&
      other.fontFamily == fontFamily &&
      other.codepoint == codepoint &&
      other.name == name;

  @override
  int get hashCode => Object.hash(fontFamily, codepoint, name);
}

/// A bundled SVG asset (legacy / host-app-supplied assets).
@immutable
class BundledIconSelection extends IconSelection {
  final String assetPath;
  const BundledIconSelection(this.assetPath);

  @override
  bool operator ==(Object other) =>
      other is BundledIconSelection && other.assetPath == assetPath;

  @override
  int get hashCode => assetPath.hashCode;
}
