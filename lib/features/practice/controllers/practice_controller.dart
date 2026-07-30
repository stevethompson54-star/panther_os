import 'dart:async';
import '../models/practice_note.dart';

import 'package:flutter/foundation.dart';

import '../models/practice_block.dart';
import '../models/practice_session.dart';

class PracticeController extends ChangeNotifier {
  PracticeController({
    required this.session,
  }) : _blockTimeRemaining = Duration(
          minutes: session.blocks.isEmpty
              ? 0
              : session.blocks.first.durationMinutes,
        );

  final PracticeSession session;

  Timer? _timer;
final List<PracticeNote> _practiceNotes = [];
  int _currentBlockIndex = 0;

  Duration _sessionElapsed = Duration.zero;
  Duration _blockTimeRemaining;

  bool _isPracticeStarted = false;
  bool _isPracticePaused = false;
  bool _isPracticeComplete = false;

  int get currentBlockIndex => _currentBlockIndex;

  Duration get sessionElapsed => _sessionElapsed;

  Duration get blockTimeRemaining => _blockTimeRemaining;

  bool get isPracticeStarted => _isPracticeStarted;

  bool get isPracticePaused => _isPracticePaused;

  bool get isPracticeComplete => _isPracticeComplete;

  bool get isTimerRunning => _timer?.isActive ?? false;

  bool get hasBlocks => session.blocks.isNotEmpty;

List<PracticeNote> get practiceNotes =>
    List.unmodifiable(_practiceNotes);

int get practiceNoteCount => _practiceNotes.length;


  void deletePracticeNote(PracticeNote note) {
    final wasRemoved = _practiceNotes.remove(note);

    if (wasRemoved) {
      notifyListeners();
    }
  }

  void addPracticeNote(String note) {
    final cleanedNote = note.trim();

    if (cleanedNote.isEmpty) {
      return;
    }

    _practiceNotes.add(
      PracticeNote(
        text: cleanedNote,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  PracticeBlock? get currentBlock {
    if (!hasBlocks || _isPracticeComplete) {
      return null;
    }

    return session.blocks[_currentBlockIndex];
  }

  PracticeBlock? get previousBlock {
    if (!hasBlocks || _currentBlockIndex <= 0) {
      return null;
    }

    return session.blocks[_currentBlockIndex - 1];
  }

  PracticeBlock? get nextBlock {
    if (!hasBlocks || _isPracticeComplete) {
      return null;
    }

    final nextIndex = _currentBlockIndex + 1;

    if (nextIndex >= session.blocks.length) {
      return null;
    }

    return session.blocks[nextIndex];
  }

  int get completedBlockCount {
    if (_isPracticeComplete) {
      return session.blockCount;
    }

    return _currentBlockIndex;
  }

  int get remainingBlockCount {
    if (_isPracticeComplete) {
      return 0;
    }

    return session.blockCount - _currentBlockIndex;
  }

  double get progress {
    if (!hasBlocks || session.totalDurationMinutes <= 0) {
      return 0;
    }

    if (_isPracticeComplete) {
      return 1;
    }

    var completedSeconds = 0;

    for (var index = 0; index < _currentBlockIndex; index++) {
      completedSeconds +=
          session.blocks[index].durationMinutes * 60;
    }

    final activeBlock = currentBlock;

    if (activeBlock != null) {
      final activeBlockTotalSeconds =
          activeBlock.durationMinutes * 60;

      final activeBlockElapsedSeconds =
          activeBlockTotalSeconds -
          _blockTimeRemaining.inSeconds;

      completedSeconds += activeBlockElapsedSeconds.clamp(
        0,
        activeBlockTotalSeconds,
      );
    }

    final totalSessionSeconds =
        session.totalDurationMinutes * 60;

    return (completedSeconds / totalSessionSeconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  double get currentBlockProgress {
    final block = currentBlock;

    if (block == null || block.durationMinutes <= 0) {
      return 0;
    }

    final totalSeconds = block.durationMinutes * 60;
    final remainingSeconds = _blockTimeRemaining.inSeconds;
    final elapsedSeconds = totalSeconds - remainingSeconds;

    return (elapsedSeconds / totalSeconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  bool get canMoveToPreviousBlock =>
      hasBlocks &&
      !_isPracticeComplete &&
      _currentBlockIndex > 0;

  bool get canMoveToNextBlock =>
      hasBlocks &&
      !_isPracticeComplete &&
      _currentBlockIndex < session.blocks.length - 1;

  void beginPractice() {
    if (!hasBlocks || _isPracticeComplete) {
      return;
    }

    _isPracticeStarted = true;
    _isPracticePaused = false;

    _startTimer();

    notifyListeners();
  }

  void startPractice() {
    beginPractice();
  }

  void pausePractice() {
    if (!_isPracticeStarted ||
        _isPracticePaused ||
        _isPracticeComplete) {
      return;
    }

    _isPracticePaused = true;
    _stopTimer();

    notifyListeners();
  }

  void resumePractice() {
    if (!_isPracticeStarted ||
        !_isPracticePaused ||
        _isPracticeComplete) {
      return;
    }

    _isPracticePaused = false;
    _startTimer();

    notifyListeners();
  }

  void togglePause() {
    if (!_isPracticeStarted || _isPracticeComplete) {
      return;
    }

    if (_isPracticePaused) {
      resumePractice();
    } else {
      pausePractice();
    }
  }

  void moveToNextBlock() {
    if (!hasBlocks || _isPracticeComplete) {
      return;
    }

    final isLastBlock =
        _currentBlockIndex == session.blocks.length - 1;

    if (isLastBlock) {
      completePractice();
      return;
    }

    _currentBlockIndex++;
    _isPracticeStarted = true;
    _isPracticePaused = false;

    _resetCurrentBlockTimer();
    _startTimer();

    notifyListeners();
  }

  void moveToPreviousBlock() {
    if (!canMoveToPreviousBlock) {
      return;
    }

    _currentBlockIndex--;
    _isPracticePaused = false;

    _resetCurrentBlockTimer();

    if (_isPracticeStarted) {
      _startTimer();
    }

    notifyListeners();
  }

  void jumpToBlock(int index) {
    if (!hasBlocks ||
        index < 0 ||
        index >= session.blocks.length) {
      return;
    }

    _currentBlockIndex = index;
    _isPracticeComplete = false;
    _isPracticeStarted = true;
    _isPracticePaused = false;

    _resetCurrentBlockTimer();
    _startTimer();

    notifyListeners();
  }

  void completePractice() {
    if (_isPracticeComplete) {
      return;
    }

    _stopTimer();

    _isPracticeComplete = true;
    _isPracticeStarted = false;
    _isPracticePaused = false;
    _blockTimeRemaining = Duration.zero;

    notifyListeners();
  }

  void restartPractice() {
    _stopTimer();

    _currentBlockIndex = 0;
    _sessionElapsed = Duration.zero;
    _isPracticeStarted = false;
    _isPracticePaused = false;
    _isPracticeComplete = false;

    _resetCurrentBlockTimer();

    notifyListeners();
  }

  void _startTimer() {
    if (_timer?.isActive ?? false) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTimerTick(),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleTimerTick() {
    if (!_isPracticeStarted ||
        _isPracticePaused ||
        _isPracticeComplete) {
      return;
    }

    _sessionElapsed += const Duration(seconds: 1);

    if (_blockTimeRemaining.inSeconds > 0) {
      _blockTimeRemaining -= const Duration(seconds: 1);
    }

    notifyListeners();
  }

  void _resetCurrentBlockTimer() {
  final block = currentBlock;

  _blockTimeRemaining = Duration(
    minutes: block?.durationMinutes ?? 0,
  );
}

void addThirtySeconds() {
  if (!hasBlocks || _isPracticeComplete) {
    return;
  }

  _blockTimeRemaining += const Duration(seconds: 30);

  notifyListeners();
}
void restartCurrentBlock() {
  if (!hasBlocks || _isPracticeComplete) {
    return;
  }

  _blockTimeRemaining = Duration(
    minutes: currentBlock?.durationMinutes ?? 0,
  );

  notifyListeners();
}
@override
void dispose() {
  _stopTimer();
  super.dispose();
}
}