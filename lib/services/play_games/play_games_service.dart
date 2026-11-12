import 'package:games_services/games_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playGamesServiceProvider = Provider<PlayGamesService>((ref) {
  return PlayGamesService();
});

class PlayGamesService {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  // Achievement IDs from Google Play Console
  // Word Count Achievements (Incremental)
  static const String achievementNoviceRaider = 'CggI3oKIyhMQAhAB';      // 50 words
  static const String achievementApprenticeHunter = 'CggI3oKIyhMQAhAC';  // 200 words
  static const String achievementExpertSolver = 'CggI3oKIyhMQAhAD';      // 500 words
  static const String achievementMasterLinguist = 'CggI3oKIyhMQAhAE';    // 1000 words
  static const String achievementLegendaryWordSmith = 'CggI3oKIyhMQAhAF'; // 2000 words

  // Leaderboard IDs from Google Play Console
  static const String leaderboardBestScore = 'CggI3oKIyhMQAhAG';
  static const String leaderboardDailyChallenge = 'CggI3oKIyhMQAhAH';

  Future<bool> signIn() async {
    try {
      print('Attempting Play Games sign in...');
      final result = await GamesServices.signIn();
      if (result != null && result.isNotEmpty) {
        _isSignedIn = true;
        print('Play Games sign in successful for player: $result');
      } else {
        _isSignedIn = false;
        print('Play Games sign in failed: result was null or empty. This usually implies a SHA-1 mismatch or PGS configuration is not published.');
      }
      return _isSignedIn;
    } catch (e) {
      print('Error during Play Games sign in: $e');
      _isSignedIn = false;
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      // Note: games_services 4.x doesn't have signOut method
      // Sign out is handled by the system
      _isSignedIn = false;
      print('Signed out from Play Games');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> unlockAchievement(String achievementId) async {
    if (!_isSignedIn) {
      print('Not signed in, cannot unlock achievement');
      return;
    }

    try {
      await GamesServices.unlock(achievement: Achievement(androidID: achievementId));
      print('Achievement unlocked: $achievementId');
    } catch (e) {
      print('Error unlocking achievement: $e');
    }
  }

  Future<void> incrementAchievement(String achievementId) async {
    if (!_isSignedIn) return;

    try {
      // Note: games_services 4.x increment doesn't take steps parameter
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementId),
      );
      print('Achievement incremented: $achievementId');
    } catch (e) {
      print('Error incrementing achievement: $e');
    }
  }

  Future<void> submitScore(String leaderboardId, int score) async {
    if (!_isSignedIn) {
      print('Not signed in, cannot submit score');
      return;
    }

    try {
      await GamesServices.submitScore(
        score: Score(
          androidLeaderboardID: leaderboardId,
          value: score,
        ),
      );
      print('Score submitted: $score to $leaderboardId');
    } catch (e) {
      print('Error submitting score: $e');
    }
  }

  // Submit score to Best Score leaderboard (for Classic, Timeless, Raid modes)
  Future<void> submitBestScore(int score) async {
    await submitScore(leaderboardBestScore, score);
  }

  // Submit score to Daily Challenge leaderboard
  Future<void> submitDailyChallengeScore(int score) async {
    await submitScore(leaderboardDailyChallenge, score);
  }

  Future<void> showAchievements() async {
    try {
      if (!_isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Play Games. Check SHA-1 and PGS publishing status.');
        }
      }
      print('Showing achievements...');
      await GamesServices.showAchievements();
      print('Achievements shown successfully');
    } catch (e) {
      print('Error showing achievements: $e');
      rethrow; 
    }
  }

  Future<void> showLeaderboards() async {
    try {
      if (!_isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Play Games. Check SHA-1 and PGS publishing status.');
        }
      }
      print('Showing leaderboards with ID: $leaderboardBestScore');
      await GamesServices.showLeaderboards(
        androidLeaderboardID: leaderboardBestScore,
      );
      print('Leaderboards shown successfully');
    } catch (e) {
      print('Error showing leaderboards: $e');
      rethrow;
    }
  }

  // Show a specific leaderboard
  Future<void> showBestScoreLeaderboard() async {
    if (!_isSignedIn) {
      final signedIn = await signIn();
      if (!signedIn) return;
    }

    try {
      await GamesServices.showLeaderboards(
        androidLeaderboardID: leaderboardBestScore,
      );
    } catch (e) {
      print('Error showing Best Score leaderboard: $e');
    }
  }

  Future<void> showDailyChallengeLeaderboard() async {
    if (!_isSignedIn) {
      final signedIn = await signIn();
      if (!signedIn) return;
    }

    try {
      await GamesServices.showLeaderboards(
        androidLeaderboardID: leaderboardDailyChallenge,
      );
    } catch (e) {
      print('Error showing Daily Challenge leaderboard: $e');
    }
  }

  // Update incremental achievements based on total words found
  Future<void> updateWordCountAchievements(int totalWords) async {
    if (!_isSignedIn) return;

    try {
      // For incremental achievements, we need to set the current step count
      // Each achievement will automatically unlock when reaching its target
      
      // Novice Raider - 50 words
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementNoviceRaider),
      );

      // Apprentice Hunter - 200 words  
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementApprenticeHunter),
      );

      // Expert Solver - 500 words
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementExpertSolver),
      );

      // Master Linguist - 1000 words
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementMasterLinguist),
      );

      // Legendary Word Smith - 2000 words
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementLegendaryWordSmith),
      );

      print('Word count achievements updated for $totalWords words');
    } catch (e) {
      print('Error updating word count achievements: $e');
    }
  }

  // Call this after each word is found to increment all achievements by 1
  Future<void> onWordFound() async {
    if (!_isSignedIn) return;

    try {
      // Increment all word count achievements by 1
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementNoviceRaider),
      );
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementApprenticeHunter),
      );
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementExpertSolver),
      );
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementMasterLinguist),
      );
      await GamesServices.increment(
        achievement: Achievement(androidID: achievementLegendaryWordSmith),
      );
    } catch (e) {
      print('Error incrementing achievements: $e');
    }
  }
}
