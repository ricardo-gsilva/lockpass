import 'package:equatable/equatable.dart';

sealed class ListItemStatus extends Equatable {
  const ListItemStatus();

  @override
  List<Object?> get props => const [];
}

class ListItemInitial extends ListItemStatus {
  const ListItemInitial();
}

class ListItemLoading extends ListItemStatus {
  const ListItemLoading();
}

class ListItemLoaded extends ListItemStatus {
  const ListItemLoaded();
}

class ListItemError extends ListItemStatus {
  final String message;
  const ListItemError(this.message);

  @override
  List<Object?> get props => [message];
}

class ListItemSuccess extends ListItemStatus {
  final String message;
  const ListItemSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ListItemActionSuccess extends ListItemStatus {
  final String message;
  const ListItemActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TrashAuthSuccess extends ListItemStatus {
  const TrashAuthSuccess();
}

class TrashAuthFailure extends ListItemStatus {
  final String message;
  const TrashAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ItemRestoredSuccess extends ListItemStatus {
  const ItemRestoredSuccess();
}
class ItemDeletedPermanentlySuccess extends ListItemStatus {
  const ItemDeletedPermanentlySuccess();
}
class ItemUpdatedSuccess extends ListItemStatus {
  const ItemUpdatedSuccess();
}
