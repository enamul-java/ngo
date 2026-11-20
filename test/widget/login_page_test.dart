

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngo/core/config/text_config.dart';
import 'package:ngo/core/network/api_client.dart';
import 'package:ngo/core/theme/app_theme.dart';
import 'package:ngo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ngo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ngo/features/auth/domain/usecases/login.dart';
import 'package:ngo/features/auth/domain/usecases/register.dart';
import 'package:ngo/features/auth/presentation/pages/login_page.dart';
import 'package:ngo/features/auth/presentation/providers/auth_provider.dart';
import 'package:ngo/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets( 'login when button is tapped', (tester) async {

      final apiClient = ApiClient();
      final dataSource = AuthRemoteDataSourceImpl(apiClient);
      final repository = AuthRepositoryImpl(dataSource);

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: Login(repository),
            registerUseCase: Register(repository),
          ),
          child: const NgoAuthApp(),
        ),
      );

      /**
       * Find the widget you want to test
       * 1. find.byType(Button) with first, last or index
       * 2. find.text("Login")
       * 3. find.byKey("loginButton")
       * 4. find.byIcon(Icon.home)
       * 5. find.byWidgetPredicate(
          (widget) => widget is Text &&
          widget.data == 'Login',
          )
       * 6. find.byValueKey
       * 7. find.byTooltip
       * 8. find.bySemanticsLabel
       * 9. find.byElementPredicate
       * 10. find.byFinder
       * 11. find.byElement
       * 12. find.byElementMatching
       * 13. find.byElementWithText
       * 14. find.byElementWithIcon
       * 15. find.byElementWithTooltip
       * 16. find.byElementWithSemanticsLabel
       * 17. find.byElementMatchingPredicate
       * 18. find.byElementMatchingFinder
       * 19. find.byElementMatchingValueKey
       * 20. find.byElementMatchingTooltip
       * 21. find.byElementMatchingSemanticsLabel
       * */
      //expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);



      /**
       *
       * 1. tester.tap(find.byType(FilledButton));
       * 2. tester.setInteractions(true);
       * 3. tester.enterText(find.byType(TextField), "enamul@gmail.com");
       * 4. tester.drag(find.byType(ListView), const Offset(0, -500));
       * 5. tester.pumpAndSettle();
       * 6. tester.pump();
       * 7. tester.pumpWidget(const MaterialApp(home: LoginPage()));
       * */
      await tester.tap(
        find.byType(FilledButton),
      );

      //Error Text Change
      await tester.pumpAndSettle();

      //.first , .last or for more then 2 same field .at(index)
      final email = find.byType(TextField).at(0);
      final password = find.byType(TextField).at(1);
      await tester.enterText(email, "enamul@gmail.com");
      await tester.enterText(password, "Password@123");

      await tester.tap(
        find.byType(FilledButton),
      );

      await tester.pumpAndSettle();

      if(TextConfig.TestForNetworkError){
        expect(find.byKey(const Key("errText")), findsOneWidget);
        //server not reachable error test
        expect(find.text("Request failed (400)"), findsOneWidget);
      }


      await tester.enterText(email, "");
      await tester.enterText(password, "");

      await tester.tap(
        find.byType(FilledButton),
      );

      await tester.pumpAndSettle();

      expect(find.text("Email is required"), findsOneWidget);
      expect(find.text("Password is required"), findsOneWidget);

    },
  );
}
/*
pumpWidget()

Builds the widget.

await tester.pumpWidget(
  const MyApp(),
);
pump()

Rebuilds after state changes.

await tester.pump();
pumpAndSettle()

Waits until animations/futures settle.

await tester.pumpAndSettle();
tap()

Simulates user tap.

await tester.tap(
  find.text('Login'),
);
enterText()

Enters text into a field.

await tester.enterText(
  find.byType(TextField),
  'enamul@gmail.com',
);
drag()

Simulates scrolling/dragging.

await tester.drag(
  find.byType(ListView),
  const Offset(0, -500),
);


Flutter provides several ways to find widgets.

By text
find.text('Login')
By widget type
find.byType(ElevatedButton)
By key
find.byKey(
  const Key('loginButton'),
)
By icon
find.byIcon(Icons.login)
By predicate
find.byWidgetPredicate(
  (widget) => widget is Text &&
      widget.data == 'Login',
)
 */