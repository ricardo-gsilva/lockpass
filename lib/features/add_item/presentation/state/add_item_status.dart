sealed class AddItemStatus {
  const AddItemStatus();
}

class AddItemInitial extends AddItemStatus {
  const AddItemInitial();
}
class AddItemLoading extends AddItemStatus {
  const AddItemLoading();
}
class AddItemSuccess extends AddItemStatus {
  const AddItemSuccess();
}
class AddItemFailure extends AddItemStatus {
  final String message;
  const AddItemFailure(this.message);
}