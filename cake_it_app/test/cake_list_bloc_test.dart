import 'package:bloc_test/bloc_test.dart';
import 'package:cake_it_app/src/data/cake_api_client.dart';
import 'package:cake_it_app/src/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cake_list/bloc/cake_list_bloc.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCakeRepository extends Mock implements CakeRepository {}

void main() {
  late MockCakeRepository mockRepository;

  const testCakes = [
    Cake(title: 'Lemon Drizzle', description: 'Tangy', image: ''),
    Cake(title: 'Victoria Sponge', description: 'Classic', image: ''),
  ];

  setUp(() {
    mockRepository = MockCakeRepository();
  });

  group('CakeListBloc', () {
    test('initial state is CakeListState()', () {
      final bloc = CakeListBloc(cakeRepository: mockRepository);
      expect(bloc.state, const CakeListState());
      bloc.close();
    });

    group('CakeListFetched', () {
      blocTest<CakeListBloc, CakeListState>(
        'emits [loading, success] when fetch succeeds',
        setUp: () {
          when(() => mockRepository.fetchCakes())
              .thenAnswer((_) async => testCakes);
        },
        build: () => CakeListBloc(cakeRepository: mockRepository),
        act: (bloc) => bloc.add(const CakeListFetched()),
        expect: () => [
          const CakeListState(status: CakeListStatus.loading),
          const CakeListState(
            status: CakeListStatus.success,
            cakes: testCakes,
          ),
        ],
      );

      blocTest<CakeListBloc, CakeListState>(
        'emits [loading, failure] when fetch throws CakeApiException',
        setUp: () {
          when(() => mockRepository.fetchCakes())
              .thenThrow(const CakeApiException('Network error'));
        },
        build: () => CakeListBloc(cakeRepository: mockRepository),
        act: (bloc) => bloc.add(const CakeListFetched()),
        expect: () => [
          const CakeListState(status: CakeListStatus.loading),
          const CakeListState(
            status: CakeListStatus.failure,
            errorMessage: 'Network error',
          ),
        ],
      );

      blocTest<CakeListBloc, CakeListState>(
        'emits [loading, failure] with generic message when unexpected error',
        setUp: () {
          when(() => mockRepository.fetchCakes()).thenThrow(Exception('oops'));
        },
        build: () => CakeListBloc(cakeRepository: mockRepository),
        act: (bloc) => bloc.add(const CakeListFetched()),
        expect: () => [
          const CakeListState(status: CakeListStatus.loading),
          const CakeListState(
            status: CakeListStatus.failure,
            errorMessage: 'An unexpected error occurred. Please try again.',
          ),
        ],
      );
    });

    group('CakeListRefreshed', () {
      blocTest<CakeListBloc, CakeListState>(
        'emits [success] with new data when refresh succeeds',
        setUp: () {
          when(() => mockRepository.fetchCakes())
              .thenAnswer((_) async => testCakes);
        },
        build: () => CakeListBloc(cakeRepository: mockRepository),
        seed: () => const CakeListState(
          status: CakeListStatus.success,
          cakes: [],
        ),
        act: (bloc) => bloc.add(const CakeListRefreshed()),
        expect: () => [
          const CakeListState(
            status: CakeListStatus.success,
            cakes: testCakes,
          ),
        ],
      );

      blocTest<CakeListBloc, CakeListState>(
        'keeps existing cakes and surfaces error on refresh failure',
        setUp: () {
          when(() => mockRepository.fetchCakes())
              .thenThrow(const CakeApiException('Timeout'));
        },
        build: () => CakeListBloc(cakeRepository: mockRepository),
        seed: () => const CakeListState(
          status: CakeListStatus.success,
          cakes: testCakes,
        ),
        act: (bloc) => bloc.add(const CakeListRefreshed()),
        expect: () => [
          const CakeListState(
            status: CakeListStatus.success,
            cakes: testCakes,
            errorMessage: 'Timeout',
          ),
        ],
      );
    });
  });
}
