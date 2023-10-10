import 'package:app/others/pole.dart';
import 'package:flame/components.dart';
import 'package:app/others/game.dart';
import 'package:app/others/space_magnet.dart';

class Player extends SpaceMagnet {
  Player() : super();

  @override
  String name = 'プレイヤー';

  @override
  Pole pole = Pole.n;

  @override
  double power = 2.0;

  @override
  double radius = 40;

  late final Sprite spriteCacheN;
  late final Sprite spriteCacheS;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    spriteCacheS = await game.loadSprite('magfo-s.png');
    spriteCacheN = await game.loadSprite('magfo-n.png');
    sprite = spriteCacheN;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // プレイヤーマグネットに追従
    final playerMagnet = (game as MyGame).playerMagnet;
    final verctor = playerMagnet.position - position;
    final distance = verctor.length;
    // 離れているほど プレイヤーマグネットは強い
    final force = verctor * dt * distance * 0.03;
    verocity += force;
  }

  Future<void> togglePole() async {
    if (pole == Pole.n) {
      pole = Pole.s;
      sprite = spriteCacheS;
    } else {
      pole = Pole.n;
      sprite = spriteCacheN;
    }
  }
}
