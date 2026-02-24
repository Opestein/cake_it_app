import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cake_it_app/src/data/cake_api_client.dart';
import 'package:cake_it_app/src/data/cake_repository.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:equatable/equatable.dart';

part 'cake_list_event.dart';
part 'cake_list_state.dart';

class CakeListBloc extends Bloc<CakeListEvent, CakeListState> {
  CakeListBloc({required CakeRepository cakeRepository})
      : _cakeRepository = cakeRepository,
        super(const CakeListState()) {
    on<CakeListFetched>(_onFetched);
    on<CakeListRefreshed>(_onRefreshed);
  }

  final CakeRepository _cakeRepository;

  Future<void> _onFetched(
    CakeListFetched event,
    Emitter<CakeListState> emit,
  ) async {
    emit(state.copyWith(status: CakeListStatus.loading));
    try {
      final cakes = await _cakeRepository.fetchCakes();
      emit(state.copyWith(
        status: CakeListStatus.success,
        cakes: cakes,
        errorMessage: () => null,
      ));
    } on CakeApiException catch (e) {
      emit(state.copyWith(
        status: CakeListStatus.failure,
        errorMessage: () => e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: CakeListStatus.failure,
        errorMessage: () => 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  Future<void> _onRefreshed(
    CakeListRefreshed event,
    Emitter<CakeListState> emit,
  ) async {
    try {
      final cakes = await _cakeRepository.fetchCakes();
      emit(state.copyWith(
        status: CakeListStatus.success,
        cakes: cakes,
        errorMessage: () => null,
      ));
    } on CakeApiException catch (e) {
      // On refresh failure, keep existing data but surface the error.
      emit(state.copyWith(errorMessage: () => e.message));
    } catch (_) {
      emit(state.copyWith(
        errorMessage: () => 'Failed to refresh. Please try again.',
      ));
    }
  }
}
