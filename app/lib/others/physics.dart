import 'package:app/others/space_magnet.dart';
import 'package:vector_math/vector_math_64.dart';

/// ボールが他のボールに当たったとき、移動可能なベクトル
Vector2 getMovableVelocity(Iterable<SpaceMagnet> others, SpaceMagnet ball) {
  // 移動可能なベクトル
  var verocity = ball.verocity.clone();

  for (final other in others) {
    // 他ボールへのベクトル
    final toOther = other.position - ball.position;
    final distance = toOther.length;
    if (distance <= other.radius + ball.radius) {
      // 接している もしくはそれ以上に近い
      // その方向へは進めないということ
      // 他ボールへのベクトルを正規化
      final toOtherNom = toOther.normalized();
      // 正規化した方向への射影
      final projSize = verocity.dot(toOtherNom);
      // 離れるときは何もしない
      if (projSize < 0) continue;
      // 近づこうとしたときは 防止のため 射影した成分を取り去る
      final proj = toOtherNom * projSize;
      verocity = verocity - proj;
    }
  }
  return verocity;
}
