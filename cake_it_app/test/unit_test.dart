import 'package:cake_it_app/src/models/cake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cake model', () {
    group('fromJson', () {
      test('parses a complete JSON map correctly', () {
        final json = {
          'title': 'Lemon Drizzle',
          'desc': 'A tangy lemon cake',
          'image': 'https://example.com/lemon.jpg',
        };

        final cake = Cake.fromJson(json);

        expect(cake.title, 'Lemon Drizzle');
        expect(cake.description, 'A tangy lemon cake');
        expect(cake.image, 'https://example.com/lemon.jpg');
      });

      test('provides defaults for missing fields', () {
        final cake = Cake.fromJson({});

        expect(cake.title, 'Untitled Cake');
        expect(cake.description, '');
        expect(cake.image, '');
      });

      test('handles null field values gracefully', () {
        final json = {
          'title': null,
          'desc': null,
          'image': null,
        };

        final cake = Cake.fromJson(json);

        expect(cake.title, 'Untitled Cake');
        expect(cake.description, '');
        expect(cake.image, '');
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        const cake = Cake(
          title: 'Victoria Sponge',
          description: 'Classic cake',
          image: 'https://example.com/victoria.jpg',
        );

        final json = cake.toJson();

        expect(json['title'], 'Victoria Sponge');
        expect(json['desc'], 'Classic cake');
        expect(json['image'], 'https://example.com/victoria.jpg');
      });

      test('round-trips through fromJson', () {
        const original = Cake(
          title: 'Carrot Cake',
          description: 'With cream cheese frosting',
          image: 'https://example.com/carrot.jpg',
        );

        final roundTripped = Cake.fromJson(original.toJson());

        expect(roundTripped, original);
      });
    });

    group('equality', () {
      test('two cakes with same fields are equal', () {
        const cake1 = Cake(
          title: 'Red Velvet',
          description: 'Rich and moist',
          image: 'https://example.com/red.jpg',
        );
        const cake2 = Cake(
          title: 'Red Velvet',
          description: 'Rich and moist',
          image: 'https://example.com/red.jpg',
        );

        expect(cake1, cake2);
        expect(cake1.hashCode, cake2.hashCode);
      });

      test('two cakes with different fields are not equal', () {
        const cake1 = Cake(
          title: 'Red Velvet',
          description: 'Rich and moist',
          image: 'https://example.com/red.jpg',
        );
        const cake2 = Cake(
          title: 'Chocolate',
          description: 'Dark and decadent',
          image: 'https://example.com/choc.jpg',
        );

        expect(cake1, isNot(cake2));
      });
    });

    test('toString returns readable format', () {
      const cake = Cake(
        title: 'Battenberg',
        description: 'Pink and yellow',
        image: 'https://example.com/batt.jpg',
      );

      expect(cake.toString(), 'Cake(title: Battenberg)');
    });
  });
}
