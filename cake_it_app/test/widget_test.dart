import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testCake = Cake(
    title: 'Test Cake',
    description: 'A delicious test cake for widget testing.',
    image: '', // Empty to avoid network calls in test
  );

  const testCakeWithImage = Cake(
    title: 'Cake With Image',
    description: 'Has an image URL.',
    image: 'https://example.com/cake.jpg',
  );

  Widget buildTestWidget(Widget child) {
    return MaterialApp(home: child);
  }

  group('CakeDetailsView', () {
    testWidgets('displays cake title in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const CakeDetailsView(index: 0, cake: testCake)),
      );

      // Title appears in both AppBar and body
      expect(find.text('Test Cake'), findsWidgets);
    });

    testWidgets('displays cake description', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const CakeDetailsView(index: 0, cake: testCake)),
      );

      expect(
        find.text('A delicious test cake for widget testing.'),
        findsOneWidget,
      );
    });

    testWidgets('shows placeholder icon when image is empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const CakeDetailsView(index: 0, cake: testCake)),
      );

      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('shows Image.network when image URL is provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
            const CakeDetailsView(index: 1, cake: testCakeWithImage)),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('has a Hero widget with correct tag', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const CakeDetailsView(index: 5, cake: testCake)),
      );

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'cake_image_5');
    });

    testWidgets('body is scrollable', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const CakeDetailsView(index: 0, cake: testCake)),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
