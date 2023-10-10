import 'package:app/others/pole.dart';
import 'package:app/others/space_magnet.dart';

class ExamplePlanetN extends SpaceMagnet {
  ExamplePlanetN() : super();

  @override
  String name = 'EXプラネットN';

  @override
  Pole pole = Pole.n;

  @override
  double power = 3;

  @override
  double radius = 80;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('planet-example-n.png');
  }
}
