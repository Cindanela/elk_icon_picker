import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' show PathMetrics, PathMetric;
import 'package:elk_icon_picker/src/utils/svg_path_parser.dart';

// Helper to assert paths are roughly similar based on bounds and metric length
void _expectPathMatch(Path path, Path expectedPath) {
  expect(path.getBounds(), expectedPath.getBounds());

  final pathMetrics = path.computeMetrics().toList();
  final expectedMetrics = expectedPath.computeMetrics().toList();

  expect(pathMetrics.length, expectedMetrics.length);

  for (int i = 0; i < pathMetrics.length; i++) {
    expect(pathMetrics[i].length, closeTo(expectedMetrics[i].length, 0.1));
  }
}

void main() {
  group('parseSvgPath', () {
    test('Empty path', () {
      final path = parseSvgPath('');
      expect(path.getBounds(), Rect.zero);
    });

    test('M and L (absolute move and line)', () {
      final path = parseSvgPath('M 10 10 L 20 10 L 20 20 Z');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(20, 10)
        ..lineTo(20, 20)
        ..close();

      _expectPathMatch(path, expected);
    });

    test('m and l (relative move and line)', () {
      final path = parseSvgPath('m 10 10 l 10 0 l 0 10 z');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(20, 10)
        ..lineTo(20, 20)
        ..close();

      _expectPathMatch(path, expected);
    });

    test('H and V (absolute horizontal and vertical line)', () {
      final path = parseSvgPath('M 10 10 H 20 V 20 H 10 Z');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(20, 10)
        ..lineTo(20, 20)
        ..lineTo(10, 20)
        ..close();

      _expectPathMatch(path, expected);
    });

    test('h and v (relative horizontal and vertical line)', () {
      final path = parseSvgPath('M 10 10 h 10 v 10 h -10 z');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(20, 10)
        ..lineTo(20, 20)
        ..lineTo(10, 20)
        ..close();

      _expectPathMatch(path, expected);
    });

    test('C (absolute cubic bezier)', () {
      final path = parseSvgPath('M 10 10 C 20 10, 20 20, 30 20');

      final expected = Path()
        ..moveTo(10, 10)
        ..cubicTo(20, 10, 20, 20, 30, 20);

      _expectPathMatch(path, expected);
    });

    test('c (relative cubic bezier)', () {
      final path = parseSvgPath('M 10 10 c 10 0, 10 10, 20 10');

      final expected = Path()
        ..moveTo(10, 10)
        ..cubicTo(20, 10, 20, 20, 30, 20);

      _expectPathMatch(path, expected);
    });

    test('S (absolute smooth cubic bezier)', () {
      // First C then S
      final path = parseSvgPath('M 10 10 C 20 10, 20 20, 30 20 S 40 30, 50 30');

      final expected = Path()
        ..moveTo(10, 10)
        ..cubicTo(20, 10, 20, 20, 30, 20)
        // Reflection of (20, 20) across (30, 20) is (40, 20)
        ..cubicTo(40, 20, 40, 30, 50, 30);

      _expectPathMatch(path, expected);
    });

    test('s (relative smooth cubic bezier)', () {
      final path = parseSvgPath('M 10 10 C 20 10, 20 20, 30 20 s 10 10, 20 10');

      final expected = Path()
        ..moveTo(10, 10)
        ..cubicTo(20, 10, 20, 20, 30, 20)
        // Reflection of (20, 20) across (30, 20) is (40, 20)
        // Relative to (30, 20): cp2 is (40, 30), end is (50, 30)
        ..cubicTo(40, 20, 40, 30, 50, 30);

      _expectPathMatch(path, expected);
    });

    test('Q (absolute quadratic bezier)', () {
      final path = parseSvgPath('M 10 10 Q 20 10, 20 20');

      final expected = Path()
        ..moveTo(10, 10)
        ..quadraticBezierTo(20, 10, 20, 20);

      _expectPathMatch(path, expected);
    });

    test('q (relative quadratic bezier)', () {
      final path = parseSvgPath('M 10 10 q 10 0, 10 10');

      final expected = Path()
        ..moveTo(10, 10)
        ..quadraticBezierTo(20, 10, 20, 20);

      _expectPathMatch(path, expected);
    });

    test('T (absolute smooth quadratic bezier)', () {
      final path = parseSvgPath('M 10 10 Q 20 10, 20 20 T 30 30');

      final expected = Path()
        ..moveTo(10, 10)
        ..quadraticBezierTo(20, 10, 20, 20)
        // Reflection of (20, 10) across (20, 20) is (20, 30)
        ..quadraticBezierTo(20, 30, 30, 30);

      _expectPathMatch(path, expected);
    });

    test('t (relative smooth quadratic bezier)', () {
      final path = parseSvgPath('M 10 10 Q 20 10, 20 20 t 10 10');

      final expected = Path()
        ..moveTo(10, 10)
        ..quadraticBezierTo(20, 10, 20, 20)
        // Reflection is (20, 30). Relative point is (30, 30)
        ..quadraticBezierTo(20, 30, 30, 30);

      _expectPathMatch(path, expected);
    });

    test('A (absolute arc)', () {
      final path = parseSvgPath('M 10 10 A 10 10 0 0 1 20 20');

      final expected = Path()
        ..moveTo(10, 10)
        ..arcToPoint(
          const Offset(20, 20),
          radius: const Radius.elliptical(10, 10),
          rotation: 0,
          largeArc: false,
          clockwise: true,
        );

      _expectPathMatch(path, expected);
    });

    test('a (relative arc)', () {
      final path = parseSvgPath('M 10 10 a 10 10 0 0 1 10 10');

      final expected = Path()
        ..moveTo(10, 10)
        ..arcToPoint(
          const Offset(20, 20),
          radius: const Radius.elliptical(10, 10),
          rotation: 0,
          largeArc: false,
          clockwise: true,
        );

      _expectPathMatch(path, expected);
    });

    test('Multiple coordinates for same command', () {
      final path = parseSvgPath('M 10 10 20 20 L 30 30 40 40');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(20, 20) // M continues as L
        ..lineTo(30, 30)
        ..lineTo(40, 40);

      _expectPathMatch(path, expected);
    });

    test('Scientific notation parsing', () {
      final path = parseSvgPath('M 1e1 1E1 L 2.5e1 -1.5e1');

      final expected = Path()
        ..moveTo(10, 10)
        ..lineTo(25, -15);

      _expectPathMatch(path, expected);
    });

    test('Decimals without leading zeros', () {
      final path = parseSvgPath('M .5 .5 L -.5 -.5');

      final expected = Path()
        ..moveTo(0.5, 0.5)
        ..lineTo(-0.5, -0.5);

      _expectPathMatch(path, expected);
    });
  });
}
