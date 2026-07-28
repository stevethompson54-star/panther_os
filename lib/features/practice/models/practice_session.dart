import 'package:flutter/foundation.dart';

import 'practice_block.dart';

@immutable
class PracticeSession {
  const PracticeSession({
    required this.title,
    required this.date,
    required this.blocks,
    this.location = '',
    this.notes = '',
  });

  final String title;
  final DateTime date;
  final List<PracticeBlock> blocks;
  final String location;
  final String notes;

  int get totalDurationMinutes =>
      blocks.fold(0, (sum, block) => sum + block.durationMinutes);

  Duration get totalDuration =>
      Duration(minutes: totalDurationMinutes);

  int get blockCount => blocks.length;

  PracticeSession copyWith({
    String? title,
    DateTime? date,
    List<PracticeBlock>? blocks,
    String? location,
    String? notes,
  }) {
    return PracticeSession(
      title: title ?? this.title,
      date: date ?? this.date,
      blocks: blocks ?? this.blocks,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'PracticeSession('
        'title: $title, '
        'blocks: ${blocks.length}, '
        'duration: $totalDurationMinutes min'
        ')';
  }
}