import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/user_stats.dart';
import '../services/dictionary/dictionary_service.dart';
import '../services/play_games/play_games_service.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref);
});

class GameNotifier extends StateNotifier<GameState> {
  final Ref ref;
  Timer? _gameTimer;
  int _gridSize = 4;

  GameNotifier(this.ref) : super(GameState.initial(4)) {
    _loadBestScore();
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    final bestScore = prefs.getInt('best_score') ?? 0;
    state = state.copyWith(bestScore: bestScore);
  }

  Future<void> _saveBestScore(int score) async {
    if (score > state.bestScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('best_score', score);
      state = state.copyWith(bestScore: score);
    }
  }

  void setGridSize(int size) {
    _gridSize = size;
  }

  void startGame({GameMode mode = GameMode.classic}) {
    int initialTime;
    int gridSize = 4;

    switch (mode) {
      case GameMode.classic:
        initialTime = 180; // 3 minutes
        gridSize = 4;
        break;
      case GameMode.timeless:
        initialTime = 0; // No timer
        gridSize = 4;
        break;
      case GameMode.dailyChallenge:
        initialTime = 180; // 3 minutes
        gridSize = 5; // Harder grid!
        break;
      case GameMode.raid:
        initialTime = 60; // 1 minute
        gridSize = 4;
        break;
    }

    state = GameState.initial(gridSize).copyWith(
      status: GameStatus.playing,
      bestScore: state.bestScore,
      timeRemaining: initialTime,
      mode: mode,
    );
    
    // Always start timer (it handles timeless mode internally)
    _startTimer();
    
    // Calculate all possible words in background
    Future.microtask(() async {
      final dictionaryService = ref.read(dictionaryServiceProvider);
      // Ensure dictionary is loaded
      if (!dictionaryService.isLoaded()) {
        await dictionaryService.loadDictionary();
      }
      
      if (state.status == GameStatus.playing) {
        final possibleWords = dictionaryService.findPossibleWords(state.grid);
        state = state.copyWith(allPossibleWords: possibleWords);
        debugPrint('Found ${possibleWords.length} possible words');
      }
    });
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.mode == GameMode.timeless) {
        // Increment elapsed time in timeless mode
        state = state.copyWith(elapsedTime: state.elapsedTime + 1);
      } else {
        if (state.timeRemaining > 0) {
          state = state.copyWith(timeRemaining: state.timeRemaining - 1);
        } else {
          endGame();
        }
      }
    });
  }

  void pauseGame() {
    if (state.status == GameStatus.playing) {
      _gameTimer?.cancel();
      state = state.copyWith(status: GameStatus.paused);
    }
  }

  void resumeGame() {
    if (state.status == GameStatus.paused) {
      state = state.copyWith(status: GameStatus.playing);
      _startTimer();
    }
  }

  void endGame() {
    _gameTimer?.cancel();
    state = state.copyWith(status: GameStatus.gameOver);
    _saveBestScore(state.score);
    _updateStats();
    _submitScoreToLeaderboard();
  }

  Future<void> _submitScoreToLeaderboard() async {
    final playGamesService = ref.read(playGamesServiceProvider);
    
    // Submit score to appropriate leaderboard based on game mode
    if (state.mode == GameMode.dailyChallenge) {
      await playGamesService.submitDailyChallengeScore(state.score);
    } else {
      // Classic, Timeless, and Raid all submit to Best Score leaderboard
      await playGamesService.submitBestScore(state.score);
    }
  }

  Future<void> _updateStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString('user_stats');
    UserStats stats = statsJson != null
        ? UserStats.fromJson(json.decode(statsJson))
        : UserStats();

    final now = DateTime.now();
    final lastPlayed = stats.lastPlayedDate;
    int newStreak = stats.currentStreak;

    if (lastPlayed != null) {
      final difference = now.difference(lastPlayed).inDays;
      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    stats = stats.copyWith(
      totalGamesPlayed: stats.totalGamesPlayed + 1,
      totalWordsFound: stats.totalWordsFound + state.foundWords.length,
      highestScore: state.score > stats.highestScore ? state.score : stats.highestScore,
      currentStreak: newStreak,
      longestStreak: newStreak > stats.longestStreak ? newStreak : stats.longestStreak,
      lastPlayedDate: now,
      totalScore: stats.totalScore + state.score,
    );

    await prefs.setString('user_stats', json.encode(stats.toJson()));
  }

  void addLetterToComposition(GridPosition position) {
    if (state.status != GameStatus.playing) return;
    
    // Don't add if already selected
    if (state.selectedPositions.contains(position)) return;

    final selectedPositions = List<GridPosition>.from(state.selectedPositions)..add(position);
    final currentWord = selectedPositions
        .map((pos) => state.grid[pos.row][pos.col])
        .join();

    state = state.copyWith(
      selectedPositions: selectedPositions,
      currentWord: currentWord,
    );
  }

  void removeLetterFromComposition(int index) {
    if (state.status != GameStatus.playing) return;
    if (index < 0 || index >= state.selectedPositions.length) return;

    final selectedPositions = List<GridPosition>.from(state.selectedPositions)..removeAt(index);
    final currentWord = selectedPositions
        .map((pos) => state.grid[pos.row][pos.col])
        .join();

    state = state.copyWith(
      selectedPositions: selectedPositions,
      currentWord: currentWord.isEmpty ? null : currentWord,
      clearCurrentWord: currentWord.isEmpty,
    );
  }

  // Keep existing selectTile for backward compatibility or tap-to-select
  void selectTile(int row, int col) {
    addLetterToComposition(GridPosition(row, col));
  }

  bool _isAdjacent(GridPosition pos1, GridPosition pos2) {
    final rowDiff = (pos1.row - pos2.row).abs();
    final colDiff = (pos1.col - pos2.col).abs();
    return rowDiff <= 1 && colDiff <= 1 && !(rowDiff == 0 && colDiff == 0);
  }

  void swapTiles(GridPosition pos1, GridPosition pos2) {
    if (state.status != GameStatus.playing) return;

    final newGrid = List<List<String>>.from(
      state.grid.map((row) => List<String>.from(row)),
    );

    final temp = newGrid[pos1.row][pos1.col];
    newGrid[pos1.row][pos1.col] = newGrid[pos2.row][pos2.col];
    newGrid[pos2.row][pos2.col] = temp;

    // Update current word based on new grid
    final currentWord = state.selectedPositions
        .map((pos) => newGrid[pos.row][pos.col])
        .join();

    state = state.copyWith(
      grid: newGrid,
      currentWord: currentWord.isEmpty ? null : currentWord,
      clearCurrentWord: currentWord.isEmpty,
    );
  }

  bool submitWord() {
    if (state.currentWord == null || state.currentWord!.length < 3) {
      clearSelection();
      return false;
    }

    final dictionaryService = ref.read(dictionaryServiceProvider);
    final word = state.currentWord!.toLowerCase();

    if (dictionaryService.isValidWord(word) && !state.foundWords.contains(word)) {
      // Valid word!
      final wordScore = _calculateScore(word);
      final newScore = state.score + wordScore;
      final newStreak = state.streak + 1;
      final newFoundWords = [...state.foundWords, word];

      state = state.copyWith(
        score: newScore,
        streak: newStreak,
        foundWords: newFoundWords,
        selectedPositions: [],
        clearCurrentWord: true,
      );
      
      // Update Play Games achievements
      final playGamesService = ref.read(playGamesServiceProvider);
      playGamesService.onWordFound();
      
      // Check if all words found (for Timeless mode)
      if (state.mode == GameMode.timeless && 
          state.allPossibleWords.isNotEmpty && 
          newFoundWords.length >= state.allPossibleWords.length) {
        endGame();
      }
      
      return true;
    } else {
      // Invalid word
      // Keep selection but maybe shake?
      // For now just return false so UI can handle feedback
      // clearSelection(); // Don't clear immediately, let user see it's wrong
      return false;
    }
  }

  int _calculateScore(String word) {
    final baseScore = word.length * 10;
    final streakBonus = state.streak * 5;
    return baseScore + streakBonus;
  }

  void clearSelection() {
    state = state.copyWith(
      selectedPositions: [],
      currentWord: null,
    );
  }

  void reviveGame(int extraSeconds) {
    if (state.status == GameStatus.gameOver) {
      state = state.copyWith(
        status: GameStatus.playing,
        timeRemaining: extraSeconds,
      );
      _startTimer();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
