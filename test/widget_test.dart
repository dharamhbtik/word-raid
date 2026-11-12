import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wordraid/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: WordRaidApp()));

    // Verify that the app title appears
    expect(find.text('WORD RAID'), findsOneWidget);
    
    // Verify play button exists
    expect(find.text('PLAY NOW'), findsOneWidget);
  });
}
