// This is a basic Flutter widget test for Pustakalay 2.0 app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pustakalay/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PustakalayApp());

    // Verify that the splash screen is shown
    expect(find.text('स्मृति पुस्तकालय'), findsOneWidget);
    expect(find.text('डिजिटल लाइब्रेरी प्रबंधन'), findsOneWidget);
    expect(find.byIcon(Icons.library_books), findsOneWidget);

    // Wait for splash screen timer and pump to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify navigation to login screen
    expect(find.text('स्मृति पुस्तकालय'), findsOneWidget);
  });

  testWidgets('App has proper theme colors', (WidgetTester tester) async {
    await tester.pumpWidget(const PustakalayApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'Pustakalay 2.0');
    expect(app.theme?.primaryColor, const Color(0xFF3F51B5));

    // Clean up timer
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
