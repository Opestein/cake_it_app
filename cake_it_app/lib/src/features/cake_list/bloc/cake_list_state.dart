part of 'cake_list_bloc.dart';

enum CakeListStatus { initial, loading, success, failure }

final class CakeListState extends Equatable {
  const CakeListState({
    this.status = CakeListStatus.initial,
    this.cakes = const [],
    this.errorMessage,
  });

  final CakeListStatus status;
  final List<Cake> cakes;
  final String? errorMessage;

  CakeListState copyWith({
    CakeListStatus? status,
    List<Cake>? cakes,
    String? Function()? errorMessage,
  }) {
    return CakeListState(
      status: status ?? this.status,
      cakes: cakes ?? this.cakes,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cakes, errorMessage];
}
