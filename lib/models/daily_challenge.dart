class DailyChallenge {
  final String id;
  final DateTime date;
  final int targetScore;
  final int targetWords;
  final bool isCompleted;
  final int currentScore;
  final int currentWords;

  DailyChallenge({
    required this.id,
    required this.date,
    required this.targetScore,
    required this.targetWords,
    this.isCompleted = false,
    this.currentScore = 0,
    this.currentWords = 0,
  });

  factory DailyChallenge.forToday() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    
    return DailyChallenge(
      id: 'challenge_${today.year}_${today.month}_${today.day}',
      date: DateTime(today.year, today.month, today.day),
      targetScore: 500 + (seed % 500),
      targetWords: 10 + (seed % 10),
    );
  }

  DailyChallenge copyWith({
    String? id,
    DateTime? date,
    int? targetScore,
    int? targetWords,
    bool? isCompleted,
    int? currentScore,
    int? currentWords,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      date: date ?? this.date,
      targetScore: targetScore ?? this.targetScore,
      targetWords: targetWords ?? this.targetWords,
      isCompleted: isCompleted ?? this.isCompleted,
      currentScore: currentScore ?? this.currentScore,
      currentWords: currentWords ?? this.currentWords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'targetScore': targetScore,
      'targetWords': targetWords,
      'isCompleted': isCompleted,
      'currentScore': currentScore,
      'currentWords': currentWords,
    };
  }

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'],
      date: DateTime.parse(json['date']),
      targetScore: json['targetScore'],
      targetWords: json['targetWords'],
      isCompleted: json['isCompleted'] ?? false,
      currentScore: json['currentScore'] ?? 0,
      currentWords: json['currentWords'] ?? 0,
    );
  }
}
