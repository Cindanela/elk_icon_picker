// Regenerates lib/src/gen/lucide_icons.g.dart from Lucide's published icon
// source: https://github.com/lucide-icons/lucide (ISC licensed).
//
// Usage:
//   dart run tool/generate_lucide_icons.dart
//   dart run tool/generate_lucide_icons.dart --limit=20   # smoke test
//
// Zero external dependencies (dart:io / dart:convert only), matching this
// package's no-dependency policy. Downloads ~1500 icons' SVG + metadata
// files directly from GitHub, so it needs network access and takes a
// couple of minutes for a full run.

import 'dart:convert';
import 'dart:io';

const _repoOwner = 'lucide-icons';
const _repoName = 'lucide';
const _ref = 'main';
const _apiTreeUrl =
    'https://api.github.com/repos/$_repoOwner/$_repoName/git/trees/$_ref'
    '?recursive=1';
const _rawBase = 'https://raw.githubusercontent.com/$_repoOwner/$_repoName/$_ref';

const _maxConcurrentRequests = 16;

Future<void> main(List<String> args) async {
  int? limit;
  var outputPath = 'lib/src/gen/lucide_icons.g.dart';
  for (final arg in args) {
    if (arg.startsWith('--limit=')) {
      limit = int.parse(arg.substring('--limit='.length));
    } else if (arg.startsWith('--out=')) {
      outputPath = arg.substring('--out='.length);
    }
  }
  final outputFile = File(outputPath);

  final client = HttpClient();
  try {
    stdout.writeln('Fetching repository file tree...');
    final tree = await _fetchTree(client);

    var iconNames = _iconNamesFrom(tree);
    final categoryIds = _categoryIdsFrom(tree);
    stdout.writeln(
      'Found ${iconNames.length} icons, ${categoryIds.length} categories.',
    );

    if (limit != null) {
      iconNames = (iconNames.toList()..sort()).take(limit).toSet();
      stdout.writeln('Limiting to ${iconNames.length} icons (smoke test).');
    }

    stdout.writeln('Downloading icon SVG + metadata...');
    final icons = await _fetchIcons(client, iconNames);

    stdout.writeln('Downloading category metadata...');
    final categories = await _fetchCategories(client, categoryIds);

    stdout.writeln('Generating Dart source...');
    final source = _generateSource(icons, categories);

    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(source);
    stdout.writeln('Wrote ${outputFile.path} (${icons.length} icons).');
  } finally {
    client.close(force: true);
  }
}

// ---------------------------------------------------------------------------
// Fetching
// ---------------------------------------------------------------------------

Future<List<dynamic>> _fetchTree(HttpClient client) async {
  final json = await _getJson(client, Uri.parse(_apiTreeUrl)) as Map;
  if (json['truncated'] == true) {
    stderr.writeln(
      'Warning: GitHub tree response was truncated; some files may be '
      'missing. Consider fetching subtrees individually.',
    );
  }
  return json['tree'] as List;
}

Set<String> _iconNamesFrom(List<dynamic> tree) {
  final names = <String>{};
  for (final entry in tree) {
    final path = (entry as Map)['path'] as String;
    if (path.startsWith('icons/') && path.endsWith('.svg')) {
      names.add(path.substring('icons/'.length, path.length - '.svg'.length));
    }
  }
  return names;
}

Set<String> _categoryIdsFrom(List<dynamic> tree) {
  final ids = <String>{};
  for (final entry in tree) {
    final path = (entry as Map)['path'] as String;
    if (path.startsWith('categories/') && path.endsWith('.json')) {
      ids.add(
        path.substring('categories/'.length, path.length - '.json'.length),
      );
    }
  }
  return ids;
}

class _IconSource {
  final String name; // kebab-case
  final List<String> tags;
  final List<String> categories;
  final String svg;

  _IconSource({
    required this.name,
    required this.tags,
    required this.categories,
    required this.svg,
  });
}

Future<List<_IconSource>> _fetchIcons(
  HttpClient client,
  Set<String> names,
) async {
  final sorted = names.toList()..sort();
  final results = <_IconSource>[];
  for (var i = 0; i < sorted.length; i += _maxConcurrentRequests) {
    final batch = sorted.skip(i).take(_maxConcurrentRequests);
    final batchResults = await Future.wait(
      batch.map((name) => _fetchIcon(client, name)),
    );
    results.addAll(batchResults);
    stdout.write('\r  ${results.length}/${sorted.length}');
  }
  stdout.writeln();
  results.sort((a, b) => a.name.compareTo(b.name));
  return results;
}

Future<_IconSource> _fetchIcon(HttpClient client, String name) async {
  final svgFuture = _getText(client, Uri.parse('$_rawBase/icons/$name.svg'));
  final metaFuture = _getJson(
    client,
    Uri.parse('$_rawBase/icons/$name.json'),
  );
  final svg = await svgFuture;
  final meta = await metaFuture as Map;
  return _IconSource(
    name: name,
    tags: ((meta['tags'] as List?) ?? const []).cast<String>(),
    categories: ((meta['categories'] as List?) ?? const []).cast<String>(),
    svg: svg,
  );
}

class _CategorySource {
  final String id;
  final String title;
  final String iconName; // kebab-case

  _CategorySource({
    required this.id,
    required this.title,
    required this.iconName,
  });
}

Future<List<_CategorySource>> _fetchCategories(
  HttpClient client,
  Set<String> ids,
) async {
  final sorted = ids.toList()..sort();
  final results = <_CategorySource>[];
  for (final id in sorted) {
    final meta =
        await _getJson(client, Uri.parse('$_rawBase/categories/$id.json'))
            as Map;
    results.add(
      _CategorySource(
        id: id,
        title: meta['title'] as String,
        iconName: meta['icon'] as String,
      ),
    );
  }
  return results;
}

Future<String> _getText(HttpClient client, Uri uri) async {
  final request = await client.getUrl(uri);
  request.headers.set(
    HttpHeaders.userAgentHeader,
    'elk_icon_picker-icon-generator',
  );
  final response = await request.close();
  if (response.statusCode != 200) {
    await response.drain<void>();
    throw HttpException('GET $uri failed: ${response.statusCode}');
  }
  return response.transform(utf8.decoder).join();
}

Future<dynamic> _getJson(HttpClient client, Uri uri) async =>
    jsonDecode(await _getText(client, uri));

// ---------------------------------------------------------------------------
// SVG shape parsing
// ---------------------------------------------------------------------------

class _ShapeData {
  final circles = <(double, double, double)>[];
  final ellipses = <(double, double, double, double)>[];
  final lines = <(double, double, double, double)>[];
  final rects = <(double, double, double, double, double)>[];
  final polylines = <List<(double, double)>>[];
  final polygons = <List<(double, double)>>[];
  final paths = <String>[];
}

final _tagPattern = RegExp(
  r'<(circle|ellipse|line|rect|polyline|polygon|path)\b([^>]*)/?>',
);
final _attrPattern = RegExp(r'([a-zA-Z_:-]+)="([^"]*)"');

_ShapeData _parseSvg(String svg) {
  final data = _ShapeData();

  for (final match in _tagPattern.allMatches(svg)) {
    final tag = match.group(1)!;
    final attrs = _attrs(match.group(2)!);

    switch (tag) {
      case 'circle':
        data.circles.add((_num(attrs, 'cx'), _num(attrs, 'cy'), _num(attrs, 'r')));
      case 'ellipse':
        data.ellipses.add((
          _num(attrs, 'cx'),
          _num(attrs, 'cy'),
          _num(attrs, 'rx'),
          _num(attrs, 'ry'),
        ));
      case 'line':
        data.lines.add((
          _num(attrs, 'x1'),
          _num(attrs, 'y1'),
          _num(attrs, 'x2'),
          _num(attrs, 'y2'),
        ));
      case 'rect':
        final rx = attrs.containsKey('rx')
            ? _num(attrs, 'rx')
            : _num(attrs, 'ry');
        data.rects.add((
          _num(attrs, 'x'),
          _num(attrs, 'y'),
          _num(attrs, 'width'),
          _num(attrs, 'height'),
          rx,
        ));
      case 'polyline':
        data.polylines.add(_points(attrs['points'] ?? ''));
      case 'polygon':
        data.polygons.add(_points(attrs['points'] ?? ''));
      case 'path':
        final d = attrs['d'];
        if (d != null) data.paths.add(d);
    }
  }

  return data;
}

Map<String, String> _attrs(String tagBody) {
  final attrs = <String, String>{};
  for (final match in _attrPattern.allMatches(tagBody)) {
    attrs[match.group(1)!] = match.group(2)!;
  }
  return attrs;
}

double _num(Map<String, String> attrs, String key) {
  final raw = attrs[key];
  if (raw == null || raw.isEmpty) return 0;
  return double.parse(raw);
}

List<(double, double)> _points(String raw) {
  final nums = raw
      .trim()
      .split(RegExp(r'[\s,]+'))
      .where((s) => s.isNotEmpty)
      .map(double.parse)
      .toList();
  final points = <(double, double)>[];
  for (var i = 0; i + 1 < nums.length; i += 2) {
    points.add((nums[i], nums[i + 1]));
  }
  return points;
}

// ---------------------------------------------------------------------------
// Naming
// ---------------------------------------------------------------------------

String _camelCase(String kebab) {
  final parts = kebab.split('-').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return kebab;
  final buffer = StringBuffer(parts.first);
  for (final part in parts.skip(1)) {
    buffer.write(part[0].toUpperCase());
    buffer.write(part.substring(1));
  }
  var identifier = buffer.toString();
  // Guard against a leading digit, which isn't a valid Dart identifier
  // start, even though no current Lucide icon name produces one.
  if (RegExp(r'^[0-9]').hasMatch(identifier)) {
    identifier = 'i$identifier';
  }
  return identifier;
}

// ---------------------------------------------------------------------------
// Code generation
// ---------------------------------------------------------------------------

String _generateSource(
  List<_IconSource> icons,
  List<_CategorySource> categories,
) {
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln(
    '// Generated by tool/generate_lucide_icons.dart from '
    'https://github.com/$_repoOwner/$_repoName',
  );
  buffer.writeln('// ignore_for_file: unnecessary_const, constant_identifier_names');
  buffer.writeln();
  buffer.writeln("import '../models/lucide_icon_data.dart';");
  buffer.writeln("import '../models/lucide_category.dart';");
  buffer.writeln();
  buffer.writeln('/// A registry of all Lucide icons available in the package.');
  buffer.writeln('class LucideIcons {');
  buffer.writeln('  LucideIcons._();');
  buffer.writeln();

  final identifiers = <String>[];
  for (final icon in icons) {
    final data = _parseSvg(icon.svg);
    final identifier = _camelCase(icon.name);
    identifiers.add(identifier);

    buffer.writeln(
      '  static const LucideIconData $identifier = LucideIconData(',
    );
    buffer.writeln("    name: '${icon.name}',");
    _writeTupleList(buffer, 'circles', data.circles, (v) => '(${_d(v.$1)}, ${_d(v.$2)}, ${_d(v.$3)})');
    _writeTupleList(buffer, 'ellipses', data.ellipses, (v) => '(${_d(v.$1)}, ${_d(v.$2)}, ${_d(v.$3)}, ${_d(v.$4)})');
    _writeTupleList(buffer, 'lines', data.lines, (v) => '(${_d(v.$1)}, ${_d(v.$2)}, ${_d(v.$3)}, ${_d(v.$4)})');
    _writeTupleList(buffer, 'rects', data.rects, (v) => '(${_d(v.$1)}, ${_d(v.$2)}, ${_d(v.$3)}, ${_d(v.$4)}, ${_d(v.$5)})');
    _writePointListList(buffer, 'polylines', data.polylines);
    _writePointListList(buffer, 'polygons', data.polygons);
    if (data.paths.isNotEmpty) {
      buffer.writeln('    paths: [');
      for (final d in data.paths) {
        buffer.writeln("      '${_escape(d)}',");
      }
      buffer.writeln('    ],');
    }
    buffer.writeln('    tags: [${icon.tags.map((t) => "'${_escape(t)}'").join(', ')}],');
    buffer.writeln(
      '    categories: [${icon.categories.map((c) => "'${_escape(c)}'").join(', ')}],',
    );
    buffer.writeln('  );');
  }

  buffer.writeln('  static const List<LucideIconData> all = [');
  for (final identifier in identifiers) {
    buffer.writeln('    $identifier,');
  }
  buffer.writeln('  ];');
  buffer.writeln('}');
  buffer.writeln();
  buffer.writeln('/// Registry of all Lucide icons (see [LucideIcons.all]).');
  buffer.writeln('const List<LucideIconData> kLucideIcons = LucideIcons.all;');
  buffer.writeln();
  buffer.writeln('/// Registry of all icon categories.');
  buffer.writeln('const List<LucideCategory> kLucideCategories = [');
  for (final category in categories) {
    buffer.writeln('  LucideCategory(');
    buffer.writeln("    id: '${category.id}',");
    buffer.writeln("    title: '${_escape(category.title)}',");
    buffer.writeln(
      '    representativeIcon: LucideIcons.${_camelCase(category.iconName)},',
    );
    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  return buffer.toString();
}

void _writeTupleList<T>(
  StringBuffer buffer,
  String field,
  List<T> items,
  String Function(T) render,
) {
  if (items.isEmpty) return;
  buffer.writeln('    $field: [${items.map(render).join(', ')}],');
}

void _writePointListList(
  StringBuffer buffer,
  String field,
  List<List<(double, double)>> items,
) {
  if (items.isEmpty) return;
  buffer.writeln('    $field: [');
  for (final points in items) {
    final rendered = points.map((p) => '(${_d(p.$1)}, ${_d(p.$2)})').join(', ');
    buffer.writeln('      [$rendered],');
  }
  buffer.writeln('    ],');
}

String _d(double value) => value.toString();

String _escape(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$');
