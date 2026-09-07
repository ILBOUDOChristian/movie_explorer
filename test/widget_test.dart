import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer/app/app.dart';
import 'package:movie_explorer/app/app_routes.dart';
import 'package:movie_explorer/app/router.dart';

void main() {
  Future<GoRouter> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter();
    await tester.pumpWidget(MovieExplorerApp(router: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return router;
  }

  testWidgets('affiche l accueil et les destinations nommees', (tester) async {
    final router = await pumpApp(tester);

    expect(find.text('Movie Explorer'), findsWidgets);
    expect(find.text('Tous les films'), findsWidgets);
    expect(router.state.name, AppRoutes.home);
  });

  testWidgets('navigue vers la liste via la route nommee movies', (
    tester,
  ) async {
    final router = await pumpApp(tester);

    router.goNamed(AppRoutes.movies);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(router.state.name, AppRoutes.movies);
    expect(find.text('10 films trouvés'), findsOneWidget);
  });

  testWidgets('ouvre le detail avec parametre d identifiant', (tester) async {
    final router = await pumpApp(tester);

    router.pushNamed(
      AppRoutes.movieDetail,
      pathParameters: {AppRoutes.movieIdParam: '1'},
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(router.state.name, AppRoutes.movieDetail);
    expect(router.state.pathParameters[AppRoutes.movieIdParam], '1');
    expect(find.text('Synopsis'), findsOneWidget);
    expect(find.text('Christopher Nolan'), findsWidgets);
  });

  testWidgets('transmet la recherche via query parameters', (tester) async {
    final router = await pumpApp(tester);

    router.goNamed(
      AppRoutes.movies,
      queryParameters: {AppRoutes.searchQuery: 'Nolan'},
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(router.state.uri.queryParameters[AppRoutes.searchQuery], 'Nolan');
    expect(find.textContaining('film'), findsWidgets);
  });

  testWidgets('navigue vers les favoris', (tester) async {
    final router = await pumpApp(tester);

    router.goNamed(AppRoutes.favorites);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(router.state.name, AppRoutes.favorites);
    expect(find.text('Mes Favoris'), findsOneWidget);
  });
}
