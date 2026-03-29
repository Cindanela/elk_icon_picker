import 'package:flutter/rendering.dart';

/// Parses an SVG path `d` attribute string into a Flutter [Path].
///
/// Supports all standard SVG path commands:
/// M m  L l  H h  V v  C c  S s  Q q  T t  A a  Z z
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = _tokenize(d);
  int i = 0;

  double cx = 0, cy = 0; // current point
  double? lastCpx, lastCpy; // last control point (for S/T)
  String lastCmd = '';

  double nextNum() => tokens[i++].num;

  while (i < tokens.length) {
    final tok = tokens[i++];
    if (!tok.isCmd) continue; // should always be a command here
    final cmd = tok.cmd;

    switch (cmd) {
      // ── Move ──────────────────────────────────────────────────────────────
      case 'M':
        cx = nextNum(); cy = nextNum();
        path.moveTo(cx, cy);
        lastCmd = 'M';
        while (i < tokens.length && !tokens[i].isCmd) {
          cx = nextNum(); cy = nextNum();
          path.lineTo(cx, cy);
        }
      case 'm':
        cx += nextNum(); cy += nextNum();
        path.moveTo(cx, cy);
        lastCmd = 'm';
        while (i < tokens.length && !tokens[i].isCmd) {
          cx += nextNum(); cy += nextNum();
          path.lineTo(cx, cy);
        }

      // ── Line ──────────────────────────────────────────────────────────────
      case 'L':
        while (i < tokens.length && !tokens[i].isCmd) {
          cx = nextNum(); cy = nextNum();
          path.lineTo(cx, cy);
        }
        lastCmd = 'L';
      case 'l':
        while (i < tokens.length && !tokens[i].isCmd) {
          cx += nextNum(); cy += nextNum();
          path.lineTo(cx, cy);
        }
        lastCmd = 'l';
      case 'H':
        while (i < tokens.length && !tokens[i].isCmd) {
          cx = nextNum(); path.lineTo(cx, cy);
        }
        lastCmd = 'H';
      case 'h':
        while (i < tokens.length && !tokens[i].isCmd) {
          cx += nextNum(); path.lineTo(cx, cy);
        }
        lastCmd = 'h';
      case 'V':
        while (i < tokens.length && !tokens[i].isCmd) {
          cy = nextNum(); path.lineTo(cx, cy);
        }
        lastCmd = 'V';
      case 'v':
        while (i < tokens.length && !tokens[i].isCmd) {
          cy += nextNum(); path.lineTo(cx, cy);
        }
        lastCmd = 'v';

      // ── Cubic Bezier ──────────────────────────────────────────────────────
      case 'C':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = nextNum(), y1 = nextNum();
          final x2 = nextNum(), y2 = nextNum();
          final x = nextNum(), y = nextNum();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCpx = x2; lastCpy = y2;
          cx = x; cy = y;
        }
        lastCmd = 'C';
      case 'c':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = cx + nextNum(), y1 = cy + nextNum();
          final x2 = cx + nextNum(), y2 = cy + nextNum();
          final x = cx + nextNum(), y = cy + nextNum();
          path.cubicTo(x1, y1, x2, y2, x, y);
          lastCpx = x2; lastCpy = y2;
          cx = x; cy = y;
        }
        lastCmd = 'c';

      // ── Smooth Cubic ──────────────────────────────────────────────────────
      case 'S':
        while (i < tokens.length && !tokens[i].isCmd) {
          final rx1 = (lastCmd == 'C' || lastCmd == 'S' || lastCmd == 'c' || lastCmd == 's')
              ? 2 * cx - (lastCpx ?? cx)
              : cx;
          final ry1 = (lastCmd == 'C' || lastCmd == 'S' || lastCmd == 'c' || lastCmd == 's')
              ? 2 * cy - (lastCpy ?? cy)
              : cy;
          final x2 = nextNum(), y2 = nextNum();
          final x = nextNum(), y = nextNum();
          path.cubicTo(rx1, ry1, x2, y2, x, y);
          lastCpx = x2; lastCpy = y2;
          cx = x; cy = y;
        }
        lastCmd = 'S';
      case 's':
        while (i < tokens.length && !tokens[i].isCmd) {
          final rx1 = (lastCmd == 'C' || lastCmd == 'S' || lastCmd == 'c' || lastCmd == 's')
              ? 2 * cx - (lastCpx ?? cx)
              : cx;
          final ry1 = (lastCmd == 'C' || lastCmd == 'S' || lastCmd == 'c' || lastCmd == 's')
              ? 2 * cy - (lastCpy ?? cy)
              : cy;
          final x2 = cx + nextNum(), y2 = cy + nextNum();
          final x = cx + nextNum(), y = cy + nextNum();
          path.cubicTo(rx1, ry1, x2, y2, x, y);
          lastCpx = x2; lastCpy = y2;
          cx = x; cy = y;
        }
        lastCmd = 's';

      // ── Quadratic Bezier ──────────────────────────────────────────────────
      case 'Q':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = nextNum(), y1 = nextNum();
          final x = nextNum(), y = nextNum();
          path.quadraticBezierTo(x1, y1, x, y);
          lastCpx = x1; lastCpy = y1;
          cx = x; cy = y;
        }
        lastCmd = 'Q';
      case 'q':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = cx + nextNum(), y1 = cy + nextNum();
          final x = cx + nextNum(), y = cy + nextNum();
          path.quadraticBezierTo(x1, y1, x, y);
          lastCpx = x1; lastCpy = y1;
          cx = x; cy = y;
        }
        lastCmd = 'q';

      // ── Smooth Quadratic ──────────────────────────────────────────────────
      case 'T':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = (lastCmd == 'Q' || lastCmd == 'T' || lastCmd == 'q' || lastCmd == 't')
              ? 2 * cx - (lastCpx ?? cx)
              : cx;
          final y1 = (lastCmd == 'Q' || lastCmd == 'T' || lastCmd == 'q' || lastCmd == 't')
              ? 2 * cy - (lastCpy ?? cy)
              : cy;
          final x = nextNum(), y = nextNum();
          path.quadraticBezierTo(x1, y1, x, y);
          lastCpx = x1; lastCpy = y1;
          cx = x; cy = y;
        }
        lastCmd = 'T';
      case 't':
        while (i < tokens.length && !tokens[i].isCmd) {
          final x1 = (lastCmd == 'Q' || lastCmd == 'T' || lastCmd == 'q' || lastCmd == 't')
              ? 2 * cx - (lastCpx ?? cx)
              : cx;
          final y1 = (lastCmd == 'Q' || lastCmd == 'T' || lastCmd == 'q' || lastCmd == 't')
              ? 2 * cy - (lastCpy ?? cy)
              : cy;
          final x = cx + nextNum(), y = cy + nextNum();
          path.quadraticBezierTo(x1, y1, x, y);
          lastCpx = x1; lastCpy = y1;
          cx = x; cy = y;
        }
        lastCmd = 't';

      // ── Arc ───────────────────────────────────────────────────────────────
      case 'A':
        while (i < tokens.length && !tokens[i].isCmd) {
          final rx = nextNum(), ry = nextNum();
          final xRot = nextNum();
          final largeArc = nextNum() != 0;
          final sweep = nextNum() != 0;
          final x = nextNum(), y = nextNum();
          _arcTo(path, cx, cy, rx, ry, xRot, largeArc, sweep, x, y);
          cx = x; cy = y;
        }
        lastCmd = 'A';
      case 'a':
        while (i < tokens.length && !tokens[i].isCmd) {
          final rx = nextNum(), ry = nextNum();
          final xRot = nextNum();
          final largeArc = nextNum() != 0;
          final sweep = nextNum() != 0;
          final x = cx + nextNum(), y = cy + nextNum();
          _arcTo(path, cx, cy, rx, ry, xRot, largeArc, sweep, x, y);
          cx = x; cy = y;
        }
        lastCmd = 'a';

      // ── Close ─────────────────────────────────────────────────────────────
      case 'Z':
      case 'z':
        path.close();
        lastCmd = 'Z';
    }

    if (cmd != 'C' && cmd != 'c' && cmd != 'S' && cmd != 's' &&
        cmd != 'Q' && cmd != 'q' && cmd != 'T' && cmd != 't') {
      lastCpx = null;
      lastCpy = null;
    }
  }
  return path;
}

// ── Arc conversion (SVG arc → Flutter arcToPoint) ─────────────────────────

void _arcTo(
  Path path,
  double x1, double y1,
  double rx, double ry,
  double xAxisRotationDeg,
  bool largeArc,
  bool sweep,
  double x2, double y2,
) {
  if (rx == 0 || ry == 0) {
    path.lineTo(x2, y2);
    return;
  }

  path.arcToPoint(
    Offset(x2, y2),
    radius: Radius.elliptical(rx, ry),
    rotation: xAxisRotationDeg,
    largeArc: largeArc,
    clockwise: sweep,
  );
}

// ── Tokenizer ──────────────────────────────────────────────────────────────

class _Token {
  final bool isCmd;
  final String cmd;
  final double _num;
  double get num => _num;
  const _Token.command(this.cmd) : isCmd = true, _num = 0;
  const _Token.number(this._num) : isCmd = false, cmd = '';
}

List<_Token> _tokenize(String d) {
  final result = <_Token>[];
  final re = RegExp(
    r'([MmZzLlHhVvCcSsQqTtAa])'
    r'|([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)',
  );
  for (final m in re.allMatches(d)) {
    if (m.group(1) != null) {
      result.add(_Token.command(m.group(1)!));
    } else {
      result.add(_Token.number(double.parse(m.group(2)!)));
    }
  }
  return result;
}
