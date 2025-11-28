class MonthStats {
  final int current;
  final int previous;

  MonthStats({required this.current, required this.previous});

  double get growth {
    if (current == 0 && previous == 0) return 0.0;

    final total = current + previous;
    if (total == 0) return 0.0;

    return (current / total) * 100;
  }
}
