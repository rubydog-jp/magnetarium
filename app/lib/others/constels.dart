import 'dart:convert' show jsonDecode;
import 'package:app/others/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:app/others/text_style.dart';

class _Name {
  const _Name({
    required this.id,
    required this.x,
    required this.y,
    required this.jp,
  });
  final String id;
  final double x;
  final double y;
  final String jp;
}

class _Line {
  const _Line({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
  final double startX;
  final double startY;
  final double endX;
  final double endY;
}

typedef _Star = Vector2;

Future<Iterable<_Star>> _loadStars() async {
  final text = await rootBundle.loadString(
    'assets/json/constel-stars.json',
  );
  final stars = jsonDecode(text) as List;
  return stars.map(
    (it) => Vector2(
      it['x'] as double,
      it['y'] as double,
    ),
  );
}

Future<Iterable<_Line>> _loadLines() async {
  final text = await rootBundle.loadString(
    'assets/json/constel-lines.json',
  );
  final lines = jsonDecode(text) as List;
  return lines.map(
    (it) => _Line(
      startX: it['start_x'] as double,
      startY: it['start_y'] as double,
      endX: it['end_x'] as double,
      endY: it['end_y'] as double,
    ),
  );
}

Future<Iterable<_Name>> _loadNames() async {
  final text = await rootBundle.loadString(
    'assets/json/constel-names.json',
  );
  final constels = jsonDecode(text) as List;
  return constels.map(
    (it) => _Name(
      id: it['constel_id'] as String,
      x: it['x'] as double,
      y: it['y'] as double,
      jp: it['jp'] as String,
    ),
  );
}

/// 星1つ
class _StarView extends SpriteComponent with HasGameReference {
  _StarView(
    this.fixedPosition,
  ) : super();
  final Vector2 fixedPosition;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('constel-star.png');
    size = Vector2.all(10.0);
    anchor = Anchor.center;
    position = fixedPosition;
  }
}

/// 星座の名前 1つ
class _NameView extends TextComponent {
  _NameView(
    this.name,
    this.fixedPosition,
  ) : super();
  final String name;
  final Vector2 fixedPosition;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    position = fixedPosition;
    text = name;
    textRenderer = TextPaints.general;
  }
}

/// 星座の線1つ
class _ConstelLinesPainter extends CustomPainter {
  const _ConstelLinesPainter({
    required this.lines,
  }) : super();
  final Iterable<_Line> lines;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.yellow[100]!;
    paint.strokeWidth = 0.5;
    for (final line in lines) {
      final start = Offset(line.startX, line.startY);
      final end = Offset(line.endX, line.endY);
      canvas.drawLine(
        start * spaceScale,
        end * spaceScale,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 星をまとめるコンポーネント
class _StarLayer extends PositionComponent with HasGameReference {
  _StarLayer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = _center;
    final stars = await _loadStars();
    final views = stars.map(
      (it) => _StarView(it * spaceScale),
    );
    addAll(views);
  }
}

/// 星をまとめるコンポーネント
class _NameLayer extends PositionComponent with HasGameReference {
  _NameLayer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = _center;
    final names = await _loadNames();
    final views = names.map(
      (it) => _NameView(
        it.jp,
        Vector2(
          it.x * spaceScale,
          it.y * spaceScale,
        ),
      ),
    );
    addAll(views);
  }
}

/// 星座線をまとめるコンポーネント
class _LineLayer extends CustomPainterComponent with HasGameReference {
  _LineLayer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = _center;
    final lines = await _loadLines();
    painter = _ConstelLinesPainter(lines: lines);
  }
}

final _layerSize = Vector2(4.2, 2.2) * spaceScale;
final _center = _layerSize / 2.0;

/// 星座レイヤー
class ConstelLayer extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = _layerSize;
    anchor = Anchor.center;
    position = Vector2.zero();

    addAll([
      _StarLayer(),
      _NameLayer(),
      _LineLayer(),
    ]);
  }
}
