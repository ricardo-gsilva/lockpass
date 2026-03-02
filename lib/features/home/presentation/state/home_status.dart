sealed class HomeStatus {
  const HomeStatus();
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
}

class HomeSuccess extends HomeStatus {
  const HomeSuccess();
}

class ShowPinAlert extends HomeStatus {
  const ShowPinAlert();
}