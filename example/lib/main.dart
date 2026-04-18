import 'package:elk_icon_picker/elk_icon_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'elk_icon_picker example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B1C2E)),
      ),
      home: const PickerDemo(),
    );
  }
}

class PickerDemo extends StatefulWidget {
  const PickerDemo({super.key});

  @override
  State<PickerDemo> createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> {
  IconSelection? _selection;

  void _openPicker() async {
    final result = await showElkIconPicker(
      context,
      currentSelection: _selection,
    );
    if (result != null) {
      setState(() => _selection = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('elk_icon_picker example'),
        backgroundColor: scheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            if (_selection is LucideIconSelection)
              LucideIcon(
                (_selection as LucideIconSelection).data,
                size: 64,
                color: scheme.primary,
              )
            else
              Icon(Icons.image_outlined, size: 64, color: scheme.outline),
            Text(
              _selection is LucideIconSelection
                  ? (_selection as LucideIconSelection).name
                  : 'No icon selected',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FilledButton.icon(
              onPressed: _openPicker,
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Pick an icon'),
            ),
          ],
        ),
      ),
    );
  }
}
