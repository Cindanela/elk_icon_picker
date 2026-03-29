import 'package:flutter/foundation.dart';

/// Rendering data for a single Lucide icon.
///
/// Stores SVG elements as typed tuples that map directly to Flutter Canvas
/// calls — no runtime SVG parsing for the structural elements.
/// Only SVG `<path d="...">` strings are parsed lazily (first use) and cached.
@immutable
class LucideIconData {
  final String name;

  /// `<circle cx cy r />`
  final List<(double cx, double cy, double r)> circles;

  /// `<ellipse cx cy rx ry />`
  final List<(double cx, double cy, double rx, double ry)> ellipses;

  /// `<line x1 y1 x2 y2 />`
  final List<(double x1, double y1, double x2, double y2)> lines;

  /// `<rect x y width height rx />`  (rx=ry shorthand)
  final List<(double x, double y, double w, double h, double rx)> rects;

  /// `<polyline points />` — list of (x,y) point lists
  final List<List<(double x, double y)>> polylines;

  /// `<polygon points />` — list of (x,y) point lists (closed)
  final List<List<(double x, double y)>> polygons;

  /// Raw SVG `d` attribute strings from `<path d="..." />`
  final List<String> paths;

  /// Search terms (from Lucide icon JSON `tags`)
  final List<String> tags;

  /// Category IDs this icon belongs to
  final List<String> categories;

  const LucideIconData({
    required this.name,
    this.circles = const [],
    this.ellipses = const [],
    this.lines = const [],
    this.rects = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.paths = const [],
    required this.tags,
    required this.categories,
  });

  @override
  bool operator ==(Object other) =>
      other is LucideIconData && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'LucideIconData($name)';
}
