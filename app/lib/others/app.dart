import 'package:app/others/config.dart';
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
    playerPosition.y.round(),
  );
});
final playerPoleProvider = StateProvider((ref) => Pole.n);

class UILayer extends StatelessWidget {
  const UILayer({
    super.key,
    required this.game,
  });

  final MyGame game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: MiniMap(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PoleButton(
              onPressed: game.player.togglePole,
            ),
          ),
        ],
      ),
    );
  }
}

class PoleButton extends ConsumerWidget {
  const PoleButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pole = ref.watch(playerPoleProvider);
    final imagePath = switch (pole) {
      Pole.s => 'images/button-pole-s.png',
      Pole.n => 'images/button-pole-n.png',
    };
    return SizedBox(
      width: 100,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        child: Image.asset(imagePath),
      ),
    );
  }
}

class MiniMap extends ConsumerWidget {
  const MiniMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapPos = ref.watch(mapPosProvider);
    final alignX = mapPos.$1 / (2.1 * spaceScale);
    final alignY = mapPos.$2 / (1.1 * spaceScale);
    return SizedBox(
      width: 120,
      height: 60,
      child: Stack(
        children: [
          Image.asset('images/mini-map.png'),
          Align(
            alignment: Alignment(alignX, alignY),
            child: SizedBox(
              width: 10,
              height: 10,
              child: Image.asset('images/my-location.png'),
            ),
          ),
        ],
      ),
    );
  }
}

class GameView extends ConsumerWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget(
      game: MyGame(
        onUpdate: (game) {
          // MEMO: need new instance of Vector2
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
