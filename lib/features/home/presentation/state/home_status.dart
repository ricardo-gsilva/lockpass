import 'package:equatable/equatable.dart';

sealed class HomeStatus extends Equatable {
  const HomeStatus();

  @override
  List<Object?> get props => const [];
}

class HomeInitial extends HomeStatus {
  const HomeInitial();
}

class HomeLoading extends HomeStatus {
  const HomeLoading();
}

class HomeError extends HomeStatus {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeSuccess extends HomeStatus {
  const HomeSuccess();
}

class ShowPinAlert extends HomeStatus {
  const ShowPinAlert();
}
