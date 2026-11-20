import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ngo/main.dart' as app;

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'complete login flow',
        (tester) async {

      app.main();

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).at(0),
        'enamul@gmail.com',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'Password@123',
      );

      await tester.tap(
        find.byType(FilledButton),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Dashboard'),
        findsOneWidget,
      );
    },
  );
}