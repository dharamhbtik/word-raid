class RaidMode {
  final DateTime lastRaidTime;
  final List<String> stolenLetters;
  final int recoveredLetters;
  final bool isActive;

  RaidMode({
    required this.lastRaidTime,
    this.stolenLetters = const [],
    this.recoveredLetters = 0,
    this.isActive = false,
  });

  factory RaidMode.initial() {
    return RaidMode(
      lastRaidTime: DateTime.now().subtract(const Duration(days: 1)),
      stolenLetters: [],
      recoveredLetters: 0,
      isActive: false,
    );
  }

  bool shouldTriggerRaid() {
    final now = DateTime.now();
    final difference = now.difference(lastRaidTime);
    return difference.inHours >= 24;
  }

  RaidMode triggerRaid() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final now = DateTime.now();
    final seed = now.millisecondsSinceEpoch;
    
    // Steal 5-10 random letters
    final count = 5 + (seed % 6);
    final stolen = List.generate(
      count,
      (i) => letters[(seed + i * 7) % letters.length],
    );

    return RaidMode(
      lastRaidTime: now,
      stolenLetters: stolen,
      recoveredLetters: 0,
      isActive: true,
    );
  }

  RaidMode recoverLetter() {
    if (recoveredLetters >= stolenLetters.length) {
      return copyWith(isActive: false);
    }
    
    return copyWith(
      recoveredLetters: recoveredLetters + 1,
      isActive: recoveredLetters + 1 < stolenLetters.length,
    );
  }

  RaidMode copyWith({
    DateTime? lastRaidTime,
    List<String>? stolenLetters,
    int? recoveredLetters,
    bool? isActive,
  }) {
    return RaidMode(
      lastRaidTime: lastRaidTime ?? this.lastRaidTime,
      stolenLetters: stolenLetters ?? this.stolenLetters,
      recoveredLetters: recoveredLetters ?? this.recoveredLetters,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastRaidTime': lastRaidTime.toIso8601String(),
      'stolenLetters': stolenLetters,
      'recoveredLetters': recoveredLetters,
      'isActive': isActive,
    };
  }

  factory RaidMode.fromJson(Map<String, dynamic> json) {
    return RaidMode(
      lastRaidTime: DateTime.parse(json['lastRaidTime']),
      stolenLetters: List<String>.from(json['stolenLetters'] ?? []),
      recoveredLetters: json['recoveredLetters'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }
}
