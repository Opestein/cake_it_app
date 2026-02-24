part of 'cake_list_bloc.dart';

sealed class CakeListEvent extends Equatable {
  const CakeListEvent();

  @override
  List<Object?> get props => [];
}

final class CakeListFetched extends CakeListEvent {
  const CakeListFetched();
}

final class CakeListRefreshed extends CakeListEvent {
  const CakeListRefreshed();
}
