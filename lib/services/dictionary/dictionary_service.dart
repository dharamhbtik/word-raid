import 'dart:collection';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dictionaryServiceProvider = Provider<DictionaryService>((ref) {
  return DictionaryService();
});

class DictionaryService {
  HashSet<String>? _words;
  HashSet<String>? _prefixes;
  bool _isLoaded = false;

  Future<void> loadDictionary() async {
    if (_isLoaded) return;

    try {
      final String content = await rootBundle.loadString('assets/dictionary/words.txt');
      final List<String> list = content.split('\n');
      _words = HashSet<String>();
      _prefixes = HashSet<String>();
      
      for (var w in list) {
        final word = w.trim().toLowerCase();
        if (word.isNotEmpty) {
          _words!.add(word);
          // Add all prefixes
          for (int i = 1; i <= word.length; i++) {
            _prefixes!.add(word.substring(0, i));
          }
        }
      }
      
      _isLoaded = true;
      print('Dictionary loaded with ${_words!.length} words.');
    } catch (e) {
      print('Error loading dictionary: $e');
      // Fallback
      _words = HashSet<String>.from(['word', 'raid', 'game', 'play']);
      _prefixes = HashSet<String>.from(['w', 'wo', 'wor', 'word', 'r', 'ra', 'rai', 'raid', 'g', 'ga', 'gam', 'game', 'p', 'pl', 'pla', 'play']);
      _isLoaded = true;
    }
  }

  bool isValidWord(String word) {
    if (!_isLoaded || _words == null) return false;
    return _words!.contains(word.toLowerCase());
  }

  bool isLoaded() => _isLoaded;

  Set<String> findPossibleWords(List<List<String>> grid) {
    if (!_isLoaded || _words == null || _prefixes == null) return {};

    final Set<String> found = {};
    final int rows = grid.length;
    final int cols = grid[0].length;
    final List<List<bool>> visited = List.generate(rows, (_) => List.filled(cols, false));

    void dfs(int r, int c, String currentWord) {
      // Prune if prefix not valid
      if (!_prefixes!.contains(currentWord)) return;

      if (currentWord.length >= 3 && _words!.contains(currentWord)) {
        found.add(currentWord);
      }

      visited[r][c] = true;

      // Check all 8 neighbors
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;

          final nr = r + dr;
          final nc = c + dc;

          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && !visited[nr][nc]) {
            dfs(nr, nc, currentWord + grid[nr][nc].toLowerCase());
          }
        }
      }

      visited[r][c] = false;
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        dfs(r, c, grid[r][c].toLowerCase());
      }
    }

    return found;
  }
}
