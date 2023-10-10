import 'package:app/others/constels.dart';
import 'package:app/others/physics.dart';
import 'package:app/others/space_magnet.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/holes/example_hole.dart';
import 'package:app/others/player_magnet.dart';
import 'package:app/others/player.dart';

class MyGame extends FlameGame with SingleGameInstance, PanDetector {
  MyGame({
    required this.notifyUpdate,
  }) : super();

  final player = Player();
  final playerMagnet = PlayerMagnet();
  final constelLayer = ConstelLayer();
  final holes = [
    ExampleHole(),
  ];

  void Function(MyGame game) notifyUpdate;

  Iterable<SpaceMagnet> get magnets =>
      holes
          .map(
            (it) => it.magnets,
          )
          .expand(
            (it) => it,
          )
          .toList() +
      [player];

  @override
  Color backgroundColor() => Colors.black;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await addAll([
      playerMagnet,
      constelLayer,
      ...holes,
      player, // プレーヤーは最前線
    ]);
    oldCamera.followComponent(playerMagnet);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 全マグネットを移動
    for (var magnet in magnets) {
      final others = magnets.where((it) => !identical(it, magnet));
      final movableVerocity = getMovableVelocity(others, magnet);
      magnet.position += movableVerocity;
      magnet.verocity = Vector2.zero();
    }
    notifyUpdate(this);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    playerMagnet.position -= info.delta.game;
  }
}
