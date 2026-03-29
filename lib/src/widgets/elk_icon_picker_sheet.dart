import 'package:flutter/material.dart';
import '../models/icon_source.dart';
import 'elk_icon_picker.dart';

/// Shows a Lucide icon picker in a modal bottom sheet.
///
/// Returns the selected [IconSelection] or null if the sheet was dismissed.
Future<IconSelection?> showElkIconPicker(
  BuildContext context, {
  IconSelection? currentSelection,
  Color? backgroundColor,
  Color? iconColor,
  Color? selectedColor,
  double borderRadius = 12.0,
  int crossAxisCount = 5,
  void Function(IconSelection)? onSelected,
}) {
  return showModalBottomSheet<IconSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            children: [
              // Pull handle
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Select Icon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // The Picker
              Expanded(
                child: ElkIconPicker(
                  scrollController: scrollController,
                  currentSelection: currentSelection,
                  onSelected: (selection) {
                    onSelected?.call(selection);
                    Navigator.pop(context, selection);
                  },
                  crossAxisCount: crossAxisCount,
                  iconColor: iconColor,
                  selectedColor: selectedColor,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
