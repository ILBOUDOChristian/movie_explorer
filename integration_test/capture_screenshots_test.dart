import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_explorer/app/app.dart';
import 'package:movie_explorer/app/app_routes.dart';
import 'package:movie_explorer/app/router.dart';
import 'package:movie_explorer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures ecrans reels', (tester) async {
    tester.view.physicalSize = const Size(400, 844);
    tester.view.devicePixelRatio = 1.0;

    final router = createAppRouter();
    await tester.pumpWidget(MovieExplorerApp(router: router));
    await tester.pump(const Duration(seconds: 2));
    await _capture(binding, tester, 'Accueil');

    router.goNamed(AppRoutes.movies);
    await tester.pump(const Duration(seconds: 2));
    await _capture(binding, tester, 'Bibliotheque');

    router.pushNamed(
      AppRoutes.movieDetail,
      pathParameters: {AppRoutes.movieIdParam: '1'},
    );
    await tester.pump(const Duration(seconds: 2));
    await _capture(binding, tester, 'Detail');

    router.goNamed(AppRoutes.addMovie);
    await tester.pump(const Duration(seconds: 1));
    await _capture(binding, tester, 'Ajouter');

    router.goNamed(AppRoutes.favorites);
    await tester.pump(const Duration(seconds: 1));
    await _capture(binding, tester, 'Favoris');

    router.goNamed(AppRoutes.settings);
    await tester.pump();
    tester.element(find.byType(MaterialApp)).read<ThemeProvider>().setThemeMode(
      ThemeMode.dark,
    );
    await tester.pump(const Duration(seconds: 1));
    await _capture(binding, tester, 'Sombre');
  });
}

Future<void> _capture(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  await tester.pump();
  final bytes = await binding.takeScreenshot(name);
  final file = File('docs/screenshots/$name.png');
  file.parent.createSync(recursive: true);
  await file.writeAsBytes(bytes);
}
