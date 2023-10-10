import 'package:app/items/example_item.dart';
import 'package:app/others/hole.dart';
import 'package:app/others/space_magnet.dart';
import 'package:app/planets/example_planet_n.dart';
import 'package:flame/game.dart';

class ExampleHole extends Hole {
  @override
  Iterable<SpaceMagnet> createObjects() {
    final item = ExampleItem();
    item.position = Vector2(100, 100);
    final planet = ExamplePlanetN();
    planet.position = Vector2(-400, -400);

    return [
      item,
      planet,
    ];
  }
}
