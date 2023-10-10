import 'package:app/others/config.dart';
import 'package:app/others/game.dart';
import 'package:flame/components.dart';
import 'package:app/others/pole.dart';

abstract class SpaceMagnet extends SpriteComponent with HasGameReference {
  // TODO: size, 画像名も受け取る
  SpaceMagnet() : super();

  var verocity = Vector2.zero();

  abstract String name;
  abstract Pole pole;
  abstract double power;
  abstract double radius;
  final double scope = 0.2 * spaceScale;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    size = Vector2.all(radius * 2.0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // すべてのマグネットたち

    final allMagnets = (game as MyGame).magnets;
    // 極が違うマグネットたち
    final differentPoles = allMagnets.where(
      (it) => it.pole != pole,
    );
    // 自分よりパワーが低いマグネットたち
    final weaks = differentPoles.where(
      (it) => it.power < power,
    );
    // スコープ内のマグネットたち
    final targets = weaks.where(
      (it) => it.position.distanceTo(position) < scope,
    );

    for (var target in targets) {
      final verctor = position - target.position;
      final force = verctor * dt * power;
      target.verocity += force;
    }
  }
}
