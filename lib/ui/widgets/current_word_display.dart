import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CurrentWordDisplay extends StatelessWidget {
  final String? currentWord;
  final bool isValid;

  const CurrentWordDisplay({
    super.key,
    this.currentWord,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final displayWord = currentWord ?? 'Swipe to form words';
    final hasWord = currentWord != null && currentWord!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: hasWord
            ? (isValid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2))
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasWord
              ? (isValid ? Colors.green : Colors.red)
              : Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasWord)
            Icon(
              isValid ? Icons.check_circle : Icons.cancel,
              color: isValid ? Colors.green : Colors.red,
              size: 24,
            ),
          if (hasWord) const SizedBox(width: 10),
          Flexible(
            child: Text(
              displayWord.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: hasWord ? 28 : 18,
                fontWeight: hasWord ? FontWeight.bold : FontWeight.normal,
                letterSpacing: hasWord ? 3 : 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate(target: hasWord ? 1 : 0)
        .scale(duration: 200.ms)
        .shimmer(duration: 500.ms, color: Colors.white.withOpacity(0.3));
  }
}
