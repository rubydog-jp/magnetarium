import 'package:app/others/config.dart';
import 'package:app/others/space_magnet.dart';
import 'package:flame/components.dart';
import 'package:app/others/game.dart';

enum _PlayerDistance {
  near,
  far,
}

abstract class Hole extends PositionComponent with HasGameReference {
  Hole() : super();

  var _playerDistance = _PlayerDistance.far;
  // これ以上近づいたら プレイヤーが近くにきたとみなす
  final nearScope = 0.5 * spaceScale;
  // これ以上離れたら プレイヤーが離れていったとみなす
  final farScope = 0.8 * spaceScale;

  final List<SpaceMagnet> _objects = [];

  Iterable<SpaceMagnet> get magnets => _objects;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    position = Vector2.zero();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final player = (game as MyGame).player;
    final distance = position.distanceTo(player.position);
    final _PlayerDistance newDistance;
    if (distance < nearScope) {
      newDistance = _PlayerDistance.near;
    } else if (distance > farScope) {
      newDistance = _PlayerDistance.far;
    } else {
      newDistance = _playerDistance;
    }

    final needAction = _playerDistance != newDistance;
    if (!needAction) return;

    if (newDistance == _PlayerDistance.near) {
      print('プレイヤーが近づいてきました');
      final objects = createObjects();
      _objects.addAll(objects); // 自分で記憶
      addAll(objects); // ゲームに追加
    } else if (newDistance == _PlayerDistance.far) {
      print('プレイヤーが離れていきました');
      removeAll(_objects); // ゲームからも削除
      _objects.removeWhere((_) => true); // 自分の記憶を消す
    }
    _playerDistance = newDistance;
  }

  /// override this and return objects
  Iterable<SpaceMagnet> createObjects();
}
