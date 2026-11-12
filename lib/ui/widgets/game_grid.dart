import 'package:flutter/material.dart';
import '../../models/game_state.dart';

class GameGrid extends StatelessWidget {
  final List<List<String>> grid;
  final List<GridPosition> selectedPositions;
  final Function(int row, int col) onTileSelected;
  final Function(GridPosition pos1, GridPosition pos2) onTileSwapped;
  final VoidCallback onSubmitWord;

  const GameGrid({
    super.key,
    required this.grid,
    required this.selectedPositions,
    required this.onTileSelected,
    required this.onTileSwapped,
    required this.onSubmitWord,
  });

  @override
  Widget build(BuildContext context) {
    final gridSize = grid.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxGridWidth = screenWidth * 0.9;
    final tileSize = (maxGridWidth / gridSize) - 8;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(gridSize, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(gridSize, (col) {
              final position = GridPosition(row, col);
              final isSelected = selectedPositions.contains(position);
              final selectionIndex = selectedPositions.indexOf(position);
              final letter = grid[row][col];

              return DragTarget<GridPosition>(
                onWillAccept: (data) => data != null && data != position,
                onAccept: (data) {
                  onTileSwapped(data, position);
                },
                builder: (context, candidateData, rejectedData) {
                  final isTarget = candidateData.isNotEmpty;
                  
                  // If selected, show as dimmed/used and NOT draggable
                  if (isSelected) {
                    return Container(
                      width: tileSize,
                      height: tileSize,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: tileSize * 0.4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  }

                  return Draggable<GridPosition>(
                    data: position,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: tileSize * 1.1,
                        height: tileSize * 1.1,
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: tileSize * 0.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      width: tileSize,
                      height: tileSize,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => onTileSelected(row, col),
                      child: Container(
                        width: tileSize,
                        height: tileSize,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isTarget
                                ? [
                                    const Color(0xFF667EEA).withOpacity(0.5),
                                    const Color(0xFF764BA2).withOpacity(0.5),
                                  ]
                                : [
                                    Colors.white,
                                    Colors.white.withOpacity(0.9),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: tileSize * 0.4,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF667EEA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          );
        }),
      ),
    );
  }
}
