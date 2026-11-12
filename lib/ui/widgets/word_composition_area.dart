import 'package:flutter/material.dart';
import '../../models/game_state.dart';

class WordCompositionArea extends StatelessWidget {
  final List<String> letters;
  final bool isValid;
  final Function(int index) onLetterRemoved;
  final Function(GridPosition position) onLetterAdded;
  final VoidCallback onSubmit;

  const WordCompositionArea({
    super.key,
    required this.letters,
    required this.isValid,
    required this.onLetterRemoved,
    required this.onLetterAdded,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Drop Zone / Word Display
          DragTarget<GridPosition>(
            onWillAccept: (_) => true,
            onAccept: (position) {
              onLetterAdded(position);
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;
              
              return Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isHovering 
                      ? Colors.white.withOpacity(0.3) 
                      : Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isHovering ? Colors.white : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: letters.isEmpty
                    ? Center(
                        child: Text(
                          'Drag letters here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(letters.length, (index) {
                            return GestureDetector(
                              onTap: () => onLetterRemoved(index),
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    letters[index],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF667EEA),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Helper text
          if (letters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Tap letter to remove',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),

          // Submit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (letters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      // Clear all
                      for (int i = letters.length - 1; i >= 0; i--) {
                        onLetterRemoved(i);
                      }
                    },
                    icon: const Icon(Icons.clear, color: Colors.white),
                    tooltip: 'Clear All',
                  ),
                ),
              ElevatedButton(
                onPressed: letters.length >= 3 ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValid ? const Color(0xFF4CAF50) : Colors.white,
                  foregroundColor: isValid ? Colors.white : const Color(0xFF667EEA),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: letters.length < 3 ? Colors.grey : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
