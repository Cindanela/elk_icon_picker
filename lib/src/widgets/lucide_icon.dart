import 'package:flutter/material.dart';
import '../models/lucide_icon_data.dart';
import '../utils/svg_path_parser.dart';

/// A widget that renders a Lucide icon using standard Flutter [Canvas] drawing.
///
/// This provides a zero-dependency, high-performance way to render Lucide's 
/// SVG-based icons while maintaining their stroke-based aesthetic.
class LucideIcon extends StatelessWidget {
  /// The icon data to render.
  final LucideIconData data;

  /// The size of the icon. Defaults to 24.
  final double size;

  /// The color of the icon's stroke. Defaults to current [IconTheme].
  final Color? color;

  /// The width of the icon's stroke. Defaults to 2.
  final double strokeWidth;

  /// Whether to use the icon's original rounded stroke cap/join. Defaults to true.
  final bool rounded;

  const LucideIcon(
    this.data, {
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
    this.rounded = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? Colors.black;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LucidePainter(
          data: data,
          color: iconColor,
          strokeWidth: strokeWidth,
          rounded: rounded,
        ),
      ),
    );
  }
}

class _LucidePainter extends CustomPainter {
  final LucideIconData data;
  final Color color;
  final double strokeWidth;
  final bool rounded;

  _LucidePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.rounded,
  });

  /// Cache for parsed SVG paths.
  static final Map<String, Path> _pathCache = {};

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = rounded ? StrokeCap.round : StrokeCap.butt
      ..strokeJoin = rounded ? StrokeJoin.round : StrokeJoin.miter;

    // Lucide icons are designed on a 24x24 grid.
    // We scale the canvas to match the widget's size.
    final scale = size.width / 24.0;
    canvas.scale(scale);

    // Draw circles
    for (final circle in data.circles) {
      canvas.drawCircle(Offset(circle.$1, circle.$2), circle.$3, paint);
    }

    // Draw ellipses
    for (final ellipse in data.ellipses) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(ellipse.$1, ellipse.$2),
          width: ellipse.$3 * 2,
          height: ellipse.$4 * 2,
        ),
        paint,
      );
    }

    // Draw lines
    for (final line in data.lines) {
      canvas.drawLine(Offset(line.$1, line.$2), Offset(line.$3, line.$4), paint);
    }

    // Draw rects
    for (final rect in data.rects) {
      if (rect.$5 > 0) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            rect.$1,
            rect.$2,
            rect.$1 + rect.$3,
            rect.$2 + rect.$4,
            Radius.circular(rect.$5),
          ),
          paint,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(rect.$1, rect.$2, rect.$3, rect.$4),
          paint,
        );
      }
    }

    // Draw polylines
    for (final polyline in data.polylines) {
      if (polyline.isEmpty) continue;
      final path = Path()..moveTo(polyline[0].$1, polyline[0].$2);
      for (var i = 1; i < polyline.length; i++) {
        path.lineTo(polyline[i].$1, polyline[i].$2);
      }
      canvas.drawPath(path, paint);
    }

    // Draw polygons
    for (final polygon in data.polygons) {
      if (polygon.isEmpty) continue;
      final path = Path()..moveTo(polygon[0].$1, polygon[0].$2);
      for (var i = 1; i < polygon.length; i++) {
        path.lineTo(polygon[i].$1, polygon[i].$2);
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    // Draw paths
    for (final d in data.paths) {
      final path = _pathCache.putIfAbsent(d, () => parseSvgPath(d));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LucidePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.rounded != rounded;
  }
}
