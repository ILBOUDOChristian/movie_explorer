import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_explorer/app/app.dart';
import 'package:movie_explorer/app/app_routes.dart';
import 'package:movie_explorer/app/router.dart';
import 'package:movie_explorer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('genere les captures README', skip: true, (tester) async {
    tester.view.physicalSize = const Size(400, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter();
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('screenshot-root'),
        child: MovieExplorerApp(router: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Accueil.png'),
    );

    router.goNamed(AppRoutes.movies);
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Bibliotheque.png'),
    );

    router.pushNamed(
      AppRoutes.movieDetail,
      pathParameters: {AppRoutes.movieIdParam: '1'},
    );
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Detail.png'),
    );

    router.goNamed(AppRoutes.addMovie);
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Ajouter.png'),
    );

    router.goNamed(AppRoutes.favorites);
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Favoris.png'),
    );

    router.goNamed(AppRoutes.settings);
    await tester.pump();
    tester.element(find.byType(MaterialApp)).read<ThemeProvider>().setThemeMode(
      ThemeMode.dark,
    );
    await tester.pump(const Duration(milliseconds: 800));
    await expectLater(
      find.byKey(const ValueKey('screenshot-root')),
      matchesGoldenFile('../docs/screenshots/Sombre.png'),
    );
  });
}
