import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_final/screens/login_screen.dart';

void main() {
  testWidgets('shows a Google sign-in button on the login screen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
