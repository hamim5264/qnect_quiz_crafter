import 'package:flutter/material.dart';

class QuizIconMapper {
  static IconData fromString(String? name) {
    switch (name) {
      case "book":
        return Icons.menu_book_rounded;
      case "brain":
        return Icons.psychology_rounded;
      case "target":
        return Icons.track_changes_rounded;
      case "timer":
        return Icons.timer;
      case "light":
        return Icons.lightbulb;
      case "math":
        return Icons.calculate_rounded;
      default:
        return Icons.help_outline; // fallback
    }
  }
}
