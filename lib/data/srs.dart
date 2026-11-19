/// Répétition espacée par boîtes de Leitner.
///
/// Boîte 0 : jamais entendu. Chaque écoute complète d'un mot arrivé à échéance le fait
/// monter d'une boîte ; « à revoir » le renvoie en boîte 1, à revoir tout de suite.
const leitnerIntervals = [
  Duration.zero,
  Duration(days: 1),
  Duration(days: 3),
  Duration(days: 7),
  Duration(days: 14),
  Duration(days: 30),
];

const maxBox = 5;

class LeitnerState {
  const LeitnerState({required this.box, required this.due});

  final int box;
  final DateTime? due;
}

/// Le mot a été écouté jusqu'au bout sans être signalé.
LeitnerState afterHeard(int box, DateTime? due, DateTime now) {
  // Réécouté avant l'échéance : rien ne change, l'écoute passive ne prouve pas la mémorisation.
  if (box > 0 && due != null && due.isAfter(now)) {
    return LeitnerState(box: box, due: due);
  }
  final next = (box + 1).clamp(1, maxBox);
  return LeitnerState(box: next, due: now.add(leitnerIntervals[next]));
}

/// L'utilisateur a signalé le mot « à revoir ».
LeitnerState afterLapse(DateTime now) => LeitnerState(box: 1, due: now);
