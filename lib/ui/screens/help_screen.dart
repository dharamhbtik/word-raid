import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      extendBodyBehindAppBar: true,
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
                    const Color(0xFFE0EAFC),
                    const Color(0xFFCFDEF3),
                  ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSection(
                context,
                icon: Icons.touch_app,
                title: 'Build Words',
                description:
                    'Drag letters from the grid to the top area to form words. You can also tap letters to add them.',
              ),
              _buildSection(
                context,
                icon: Icons.swap_horiz,
                title: 'Swap Letters',
                description:
                    'Drag a letter onto another letter in the grid to swap them. Use this to rearrange the grid!',
              ),
              _buildSection(
                context,
                icon: Icons.timer,
                title: 'Beat the Clock',
                description:
                    'You have 60 seconds to find as many words as possible. Keep an eye on the timer!',
              ),
              _buildSection(
                context,
                icon: Icons.local_fire_department,
                title: 'Build Streaks',
                description:
                    'Find words quickly one after another to build your streak. Higher streaks give you bonus points!',
              ),
              _buildSection(
                context,
                icon: Icons.shield,
                title: 'Raid Mode',
                description:
                    'Watch out for the Word Monster! Every 24 hours, letters might be stolen. Play rounds to recover them.',
              ),
              _buildSection(
                context,
                icon: Icons.star,
                title: 'Scoring',
                description:
                    '• 3 letters: 30 points\n• 4 letters: 40 points\n• 5+ letters: 50+ points\n• Streak Bonus: +5 points per streak level',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'GOT IT!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final iconBgColor = isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1);
    final containerBgColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.6);
    final borderColor = isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: containerBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: textColor),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
