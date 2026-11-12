class UserStats {
  final int totalGamesPlayed;
  final int totalWordsFound;
  final int highestScore;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastPlayedDate;
  final int totalScore;
  final Map<String, bool> achievements;

  UserStats({
    this.totalGamesPlayed = 0,
    this.totalWordsFound = 0,
    this.highestScore = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPlayedDate,
    this.totalScore = 0,
    this.achievements = const {},
  });

  UserStats copyWith({
    int? totalGamesPlayed,
    int? totalWordsFound,
    int? highestScore,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPlayedDate,
    int? totalScore,
    Map<String, bool>? achievements,
  }) {
    return UserStats(
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalWordsFound: totalWordsFound ?? this.totalWordsFound,
      highestScore: highestScore ?? this.highestScore,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      totalScore: totalScore ?? this.totalScore,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGamesPlayed': totalGamesPlayed,
      'totalWordsFound': totalWordsFound,
      'highestScore': highestScore,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastPlayedDate': lastPlayedDate?.toIso8601String(),
      'totalScore': totalScore,
      'achievements': achievements,
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
      totalWordsFound: json['totalWordsFound'] ?? 0,
      highestScore: json['highestScore'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.parse(json['lastPlayedDate'])
          : null,
      totalScore: json['totalScore'] ?? 0,
      achievements: Map<String, bool>.from(json['achievements'] ?? {}),
    );
  }
}
