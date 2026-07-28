import 'package:flutter/foundation.dart';

import '../models/practice_block.dart';
import '../models/practice_session.dart';

class PracticeController extends ChangeNotifier {
  PracticeController({
    required PracticeSession session,
  }) : _session = session;

  // ignore: prefer_initializing_formals
  final PracticeSession _session;

  int _currentBlockIndex = 0;
  bool _isPracticeStarted = false;
  bool _isPracticePaused = false;
  bool _isPracticeComplete = false;

  PracticeSession get session => _session;

  int get currentBlockIndex => _currentBlockIndex;

  bool get isPracticeStarted => _isPracticeStarted;

  bool get isPracticePaused => _isPracticePaused;

  bool get isPracticeComplete => _isPracticeComplete;

  bool get hasBlocks => _session.blocks.isNotEmpty;

  PracticeBlock? get currentBlock {
    if (!hasBlocks || _isPracticeComplete) {
      return null;
    }

    return _session.blocks[_currentBlockIndex];
  }

  PracticeBlock? get previousBlock {
    if (!hasBlocks || _currentBlockIndex <= 0) {
      return null;
    }

    return _session.blocks[_currentBlockIndex - 1];
  }

  PracticeBlock? get nextBlock {
    if (!hasBlocks || _isPracticeComplete) {
      return null;
    }

    final nextIndex = _currentBlockIndex + 1;

    if (nextIndex >= _session.blocks.length) {
      return null;
    }

    return _session.blocks[nextIndex];
  }

  int get completedBlockCount {
    if (_isPracticeComplete) {
      return _session.blockCount;
    }

    return _currentBlockIndex;
  }

  int get remainingBlockCount {
    if (_isPracticeComplete) {
      return 0;
    }

    return _session.blockCount - _currentBlockIndex;
  }

  double get progress {
    if (!hasBlocks) {
      return 0;
    }

    if (_isPracticeComplete) {
      return 1;
    }

    return _currentBlockIndex / _session.blockCount;
  }

  bool get canMoveToPreviousBlock =>
      hasBlocks && !_isPracticeComplete && _currentBlockIndex > 0;

  bool get canMoveToNextBlock =>
      hasBlocks &&
      !_isPracticeComplete &&
      _currentBlockIndex < _session.blocks.length - 1;

  void startPractice() {
    if (!hasBlocks || _isPracticeComplete) {
      return;
    }

    _isPracticeStarted = true;
    _isPracticePaused = false;

    notifyListeners();
  }

  void pausePractice() {
    if (!_isPracticeStarted || _isPracticeComplete) {
      return;
    }

    _isPracticePaused = true;

    notifyListeners();
  }

  void resumePractice() {
    if (!_isPracticeStarted ||
        !_isPracticePaused ||
        _isPracticeComplete) {
      return;
    }

    _isPracticePaused = false;

    notifyListeners();
  }

  void togglePause() {
    if (!_isPracticeStarted || _isPracticeComplete) {
      return;
    }

    _isPracticePaused = !_isPracticePaused;

    notifyListeners();
  }

  void moveToNextBlock() {
    if (!hasBlocks || _isPracticeComplete) {
      return;
    }

    final isLastBlock =
        _currentBlockIndex == _session.blocks.length - 1;

    if (isLastBlock) {
      completePractice();
      return;
    }

    _currentBlockIndex++;
    _isPracticeStarted = true;
    _isPracticePaused = false;

    notifyListeners();
  }

  void moveToPreviousBlock() {
    if (!canMoveToPreviousBlock) {
      return;
    }

    _currentBlockIndex--;
    _isPracticePaused = false;

    notifyListeners();
  }

  void jumpToBlock(int index) {
    if (!hasBlocks ||
        index < 0 ||
        index >= _session.blocks.length) {
      return;
    }

    _currentBlockIndex = index;
    _isPracticeComplete = false;
    _isPracticeStarted = true;
    _isPracticePaused = false;

    notifyListeners();
  }

  void completePractice() {
    if (_isPracticeComplete) {
      return;
    }

    _isPracticeComplete = true;
    _isPracticeStarted = false;
    _isPracticePaused = false;

    notifyListeners();
  }

  void restartPractice() {
    _currentBlockIndex = 0;
    _isPracticeStarted = false;
    _isPracticePaused = false;
    _isPracticeComplete = false;

    notifyListeners();
  }
}