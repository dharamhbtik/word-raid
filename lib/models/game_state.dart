import 'package:flutter/foundation.dart';

enum GameStatus {
  idle,
  playing,
  paused,
  gameOver,
}

enum GameMode {
  classic,      // Timed mode (3 minutes)
  timeless,     // No time limit
  dailyChallenge, // Daily challenge mode
  raid,         // Fast-paced raid mode (1 minute)
}

class GameState {
  final List<List<String>> grid;
  final int score;
  final int timeRemaining;
  final GameStatus status;
  final List<String> foundWords;
  final int streak;
  final String? currentWord;
  final List<GridPosition> selectedPositions;
  final int bestScore;
  final GameMode mode;
  final int elapsedTime;
  final Set<String> allPossibleWords;

  GameState({
    required this.grid,
    required this.score,
    required this.timeRemaining,
    required this.status,
    required this.foundWords,
    this.streak = 0,
    this.currentWord,
    this.selectedPositions = const [],
    this.bestScore = 0,
    this.mode = GameMode.classic,
    this.elapsedTime = 0,
    this.allPossibleWords = const {},
  });

  factory GameState.initial(int gridSize) {
    return GameState(
      grid: _generateRandomGrid(gridSize),
      score: 0,
      timeRemaining: 60,
      status: GameStatus.idle,
      foundWords: [],
      streak: 0,
      selectedPositions: [],
      bestScore: 0,
      elapsedTime: 0,
      allPossibleWords: {},
    );
  }

  static List<List<String>> _generateRandomGrid(int size) {
    // ... existing code ...
    const String vowels = 'AEIOU';
    const String consonants = 'BCDFGHJKLMNPQRSTVWXYZ';
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return List.generate(size, (i) {
      return List.generate(size, (j) {
        // Ensure good vowel/consonant distribution
        final seed = (random + i * size + j) % 10;
        if (seed < 4) {
          return vowels[(random + i + j) % vowels.length];
        } else {
          return consonants[(random + i * 2 + j * 3) % consonants.length];
        }
      });
    });
  }

  GameState copyWith({
    List<List<String>>? grid,
    int? score,
    int? timeRemaining,
    GameStatus? status,
    List<String>? foundWords,
    int? streak,
    String? currentWord,
    bool clearCurrentWord = false,
    List<GridPosition>? selectedPositions,
    int? bestScore,
    GameMode? mode,
    int? elapsedTime,
    Set<String>? allPossibleWords,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      score: score ?? this.score,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      status: status ?? this.status,
      foundWords: foundWords ?? this.foundWords,
      streak: streak ?? this.streak,
      currentWord: clearCurrentWord ? null : (currentWord ?? this.currentWord),
      selectedPositions: selectedPositions ?? this.selectedPositions,
      bestScore: bestScore ?? this.bestScore,
      mode: mode ?? this.mode,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      allPossibleWords: allPossibleWords ?? this.allPossibleWords,
    );
  }
}

class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'GridPosition($row, $col)';
}
