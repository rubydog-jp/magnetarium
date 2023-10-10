import 'package:flame/components.dart';

class PlayerMagnet extends SpriteComponent with HasGameReference {
  PlayerMagnet() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('player-magnet.png');
    position = Vector2.zero();
    size = Vector2.zero();
  }
}
