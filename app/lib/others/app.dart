import 'package:app/others/pole.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/others/game.dart';

final playerPosProvider = StateProvider((ref) => Vector2.zero());
final mapPosProvider = Provider((ref) {
  final playerPosition = ref.watch(playerPosProvider);
  return (
    playerPosition.x.round(),
    playerPosition.x.round(),
  );
});
final playerPoleProvider = StateProvider((ref) => Pole.n);

class UILayer extends ConsumerWidget {
  const UILayer({
    super.key,
    required this.game,
  });

  final MyGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapPos = ref.watch(mapPosProvider);
    final playerPole = ref.watch(playerPoleProvider);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: 50,
            height: 100,
            child: Container(
              color: Colors.amber,
              child: Text(mapPos.$1.toString()),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              game.player.togglePole();
            },
            child: Text(playerPole.name),
          ),
        ),
      ],
    );
  }
}

class GameView extends ConsumerWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget(
      game: MyGame(
        notifyUpdate: (game) {
          final playerPosition = Vector2(
            game.player.position.x,
            game.player.position.y,
          );
          ref.read(playerPosProvider.notifier).state = playerPosition;
          ref.read(playerPoleProvider.notifier).state = game.player.pole;
        },
      ),
      initialActiveOverlays: const ['UILayer'],
      overlayBuilderMap: {
        'UILayer': (_, MyGame game) => UILayer(game: game),
      },
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: GameView(),
        ),
      ),
    );
  }
}
