import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../../models/game_state.dart';
import '../../providers/game_provider.dart';
import '../../ads/ad_service.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_header.dart';
import '../widgets/word_composition_area.dart';
import '../widgets/found_words_list.dart';
import 'game_over_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  final GameMode mode;
  
  const GameScreen({super.key, this.mode = GameMode.classic});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Start game when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startGame(mode: widget.mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen for game over
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (previous?.status != GameStatus.gameOver && 
          next.status == GameStatus.gameOver) {
        _onGameOver();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (gameState.status == GameStatus.playing) {
          ref.read(gameProvider.notifier).pauseGame();
          final shouldExit = await _showExitDialog();
          if (!shouldExit) {
            ref.read(gameProvider.notifier).resumeGame();
          }
          return shouldExit;
        }
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                    ]
                  : [
                      const Color(0xFF667EEA),
                      const Color(0xFF764BA2),
                    ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Header with score and timer
                          GameHeader(
                            score: gameState.score,
                            timeRemaining: gameState.timeRemaining,
                            bestScore: gameState.bestScore,
                            isTimeless: widget.mode == GameMode.timeless,
                            elapsedTime: gameState.elapsedTime,
                            onPause: () {
                              if (widget.mode == GameMode.timeless) {
                                _showEndGameDialog();
                              } else {
                                ref.read(gameProvider.notifier).pauseGame();
                                _showPauseDialog();
                              }
                            },
                          ),

                          const SizedBox(height: 10),

                          // Word Composition Area (Drag Target)
                          WordCompositionArea(
                            letters: gameState.currentWord?.split('') ?? [],
                            isValid: _isCurrentWordValid(gameState),
                            onLetterRemoved: (index) {
                              ref.read(gameProvider.notifier).removeLetterFromComposition(index);
                            },
                            onLetterAdded: (position) {
                              ref.read(gameProvider.notifier).addLetterToComposition(position);
                              HapticFeedback.selectionClick();
                            },
                            onSubmit: () {
                              _submitWord();
                            },
                          ),

                          const SizedBox(height: 10),

                          // Game grid
                          Expanded(
                            child: Center(
                              child: DragTarget<GridPosition>(
                                onAccept: (data) {
                                  // If dropped back on grid (outside composition), maybe remove?
                                  // For now, grid handles its own drops (swapping)
                                },
                                builder: (context, _, __) {
                                  return GameGrid(
                                    grid: gameState.grid,
                                    selectedPositions: gameState.selectedPositions,
                                    onTileSelected: (row, col) {
                                      // Tap to add
                                      ref.read(gameProvider.notifier).addLetterToComposition(GridPosition(row, col));
                                      HapticFeedback.selectionClick();
                                    },
                                    onTileSwapped: (pos1, pos2) {
                                      ref.read(gameProvider.notifier).swapTiles(pos1, pos2);
                                      HapticFeedback.mediumImpact();
                                    },
                                    onSubmitWord: () {
                                      // No-op for swipe end, as we use button now
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Found words
                          FoundWordsList(
                            foundWords: gameState.foundWords,
                            streak: gameState.streak,
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _isCurrentWordValid(GameState gameState) {
    if (gameState.currentWord == null || gameState.currentWord!.length < 3) {
      return false;
    }
    // Check if already found
    if (gameState.foundWords.contains(gameState.currentWord!.toLowerCase())) {
      return false;
    }
    return true;
  }

  void _onTileSelected(int row, int col) {
    HapticFeedback.selectionClick();
    Vibration.vibrate(duration: 10);
    ref.read(gameProvider.notifier).selectTile(row, col);
  }

  void _submitWord() {
    final success = ref.read(gameProvider.notifier).submitWord();
    if (success) {
      HapticFeedback.heavyImpact();
      Vibration.vibrate(duration: 50);
      // Success sound or visual is handled by state update (word moves to list)
    } else {
      HapticFeedback.mediumImpact();
      Vibration.vibrate(duration: 100);
      
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid word or already found!'),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showEndGameDialog() {
    ref.read(gameProvider.notifier).pauseGame();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('End Game?'),
        content: const Text('Are you sure you want to finish this game?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(gameProvider.notifier).resumeGame();
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(gameProvider.notifier).endGame();
            },
            child: const Text('FINISH'),
          ),
        ],
      ),
    );
  }

  void _onGameOver() {
    final adService = ref.read(adServiceProvider);
    
    // Show interstitial ad after game
    Future.delayed(const Duration(milliseconds: 500), () {
      adService.showInterstitialAd();
    });

    // Navigate to game over screen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GameOverScreen(),
          ),
        );
      }
    });
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Game?'),
            content: const Text('Your progress will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('EXIT'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Paused'),
        content: const Text('Take a break!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(gameProvider.notifier).resumeGame();
            },
            child: const Text('RESUME'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('QUIT'),
          ),
        ],
      ),
    );
  }
}
