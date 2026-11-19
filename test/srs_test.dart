import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_balade/data/srs.dart';

void main() {
  final now = DateTime(2026, 10, 30, 9);

  test('un mot nouveau entendu passe en boîte 1, à revoir demain', () {
    final s = afterHeard(0, null, now);
    expect(s.box, 1);
    expect(s.due, now.add(const Duration(days: 1)));
  });

  test('un mot arrivé à échéance monte d\'une boîte', () {
    final s = afterHeard(2, now.subtract(const Duration(hours: 1)), now);
    expect(s.box, 3);
    expect(s.due, now.add(const Duration(days: 7)));
  });

  test('réécouter avant l\'échéance ne fait pas monter', () {
    final due = now.add(const Duration(days: 2));
    final s = afterHeard(2, due, now);
    expect(s.box, 2);
    expect(s.due, due);
  });

  test('la boîte maximale est plafonnée', () {
    expect(afterHeard(maxBox, now, now).box, maxBox);
  });

  test('« à revoir » renvoie en boîte 1, tout de suite', () {
    final s = afterLapse(now);
    expect(s.box, 1);
    expect(s.due, now);
  });
}
