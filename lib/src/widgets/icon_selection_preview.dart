import 'package:flutter/material.dart';
import '../models/icon_source.dart';
import 'lucide_icon.dart';

/// A widget that displays a preview of an [IconSelection].
///
/// This handles [LucideIconSelection], [EmojiSelection], [ImportedIconSelection],
/// and [BundledIconSelection].
class IconSelectionPreview extends StatelessWidget {
  /// The current selection to preview.
  final IconSelection? selection;

  /// The size of the icon/emoji. Defaults to 24.
  final double size;

  /// The color of the icon.
  final Color? color;

  const IconSelectionPreview({
    super.key,
    required this.selection,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final currentSelection = selection;

    if (currentSelection == null) {
      return Icon(Icons.help_outline, size: size, color: color);
    }

    switch (currentSelection) {
      case LucideIconSelection s:
        return LucideIcon(s.data, size: size, color: color);
      case EmojiSelection s:
        return Text(s.emoji, style: TextStyle(fontSize: size));
      case ImportedIconSelection s:
        return Icon(
          IconData(s.codepoint, fontFamily: s.fontFamily),
          size: size,
          color: color,
        );
      case BundledIconSelection _:
        // Note: For bundled assets, consumers might prefer a custom renderer.
        // For now, we assume it's a standard Icon or an image.
        // (In a real app, you might use SvgPicture.asset if you have the dependency)
        return Icon(Icons.image, size: size, color: color);
    }
  }
}
