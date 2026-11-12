import 'package:flutter/material.dart';

class GameHeader extends StatelessWidget {
  final int score;
  final int timeRemaining;
  final int bestScore;
  final VoidCallback onPause;
  final bool isTimeless;
  final int elapsedTime;

  const GameHeader({
    super.key,
    required this.score,
    required this.timeRemaining,
    required this.bestScore,
    required this.onPause,
    this.isTimeless = false,
    this.elapsedTime = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLowTime = timeRemaining <= 10;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score
          Expanded(
            child: _buildStatCard(
              icon: Icons.stars,
              label: 'Score',
              value: '$score',
              subValue: 'Best: $bestScore',
              color: Colors.amber,
            ),
          ),

          const SizedBox(width: 10),

          // Timer or Elapsed Time
          Expanded(
            child: _buildStatCard(
              icon: isTimeless ? Icons.access_time : Icons.timer,
              label: isTimeless ? 'Elapsed' : 'Time',
              value: isTimeless ? _formatElapsedTime(elapsedTime) : '$timeRemaining',
              subValue: isTimeless ? 'time' : 'seconds',
              color: isTimeless ? Colors.blue : (isLowTime ? Colors.red : Colors.green),
              isWarning: !isTimeless && isLowTime,
            ),
          ),

          const SizedBox(width: 10),

          // Pause or End button
          IconButton(
            onPressed: onPause,
            icon: Icon(isTimeless ? Icons.stop_circle : Icons.pause_circle_filled),
            color: Colors.white,
            iconSize: 40,
            tooltip: isTimeless ? 'End Game' : 'Pause',
          ),
        ],
      ),
    );
  }

  String _formatElapsedTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
    required Color color,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isWarning ? Colors.red : Colors.white.withOpacity(0.3),
          width: isWarning ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subValue,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
