import 'package:equatable/equatable.dart';

sealed class AddItemStatus extends Equatable {
  const AddItemStatus();

  @override
  List<Object?> get props => const [];
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

  @override
  List<Object?> get props => [message];
}
