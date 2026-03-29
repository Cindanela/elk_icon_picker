import 'package:flutter/foundation.dart';
import 'lucide_icon_data.dart';

/// A category grouping icons in the picker (e.g. "Emoji", "Devices").
@immutable
class LucideCategory {
  final String id;
  final String title;

  /// Representative icon shown on the category tab.
  final LucideIconData representativeIcon;

  const LucideCategory({
    required this.id,
    required this.title,
    required this.representativeIcon,
  });
}

/// Defines how category tabs should be rendered in the picker.
enum CategoryStyle {
  /// Both the representative icon and title are shown.
  both,

  /// Only the representative icon is shown.
  iconsOnly,

  /// Only the category title is shown.
  textOnly,
}
