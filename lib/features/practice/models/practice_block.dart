import 'package:flutter/foundation.dart';

@immutable
class PracticeBlock {
  const PracticeBlock({
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.description,
    this.coachingPoints = const [],
    this.equipment = const [],
  });

  final String title;
  final String category;
  final int durationMinutes;
  final String description;
  final List<String> coachingPoints;
  final List<String> equipment;

  Duration get duration => Duration(minutes: durationMinutes);

  PracticeBlock copyWith({
    String? title,
    String? category,
    int? durationMinutes,
    String? description,
    List<String>? coachingPoints,
    List<String>? equipment,
  }) {
    return PracticeBlock(
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      description: description ?? this.description,
      coachingPoints: coachingPoints ?? this.coachingPoints,
      equipment: equipment ?? this.equipment,
    );
  }

  @override
  String toString() {
    return 'PracticeBlock('
        'title: $title, '
        'category: $category, '
        'durationMinutes: $durationMinutes'
        ')';
  }
}