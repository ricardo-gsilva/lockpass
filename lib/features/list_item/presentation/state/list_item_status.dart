sealed class ListItemStatus {
  const ListItemStatus();
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
  ListItemError(this.message);
}

class ListItemSuccess extends ListItemStatus {
  final String message;
  ListItemSuccess(this.message);
}

class ListItemActionSuccess extends ListItemStatus {
  final String message;
  ListItemActionSuccess(this.message);
}

class TrashAuthSuccess extends ListItemStatus {
  const TrashAuthSuccess();
}

class TrashAuthFailure extends ListItemStatus {
  final String message;
  TrashAuthFailure(this.message);
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