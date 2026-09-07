import 'package:flutter_test/flutter_test.dart';
import 'package:movie_explorer/app/app.dart';
import 'package:movie_explorer/app/router.dart';

void main() {
  testWidgets('clean navigation smoke test', (tester) async {
    await tester.pumpWidget(const MovieExplorerApp());
    await tester.pump();

    expect(find.text('Movie Explorer'), findsWidgets);
    expect(find.text('Tous les films'), findsOneWidget);

    await tester.tap(find.text('Films').last);
    await tester.pumpAndSettle();
    expect(find.text('Tous les films'), findsOneWidget);
    expect(find.text('10 films trouvés'), findsOneWidget);

    await tester.tap(find.text('Favoris').last);
    await tester.pumpAndSettle();
    expect(find.text('Mes Favoris'), findsOneWidget);

    appRouter.go('/movie/1');
    await tester.pumpAndSettle();
    expect(find.text('Synopsis'), findsOneWidget);
  });
}
