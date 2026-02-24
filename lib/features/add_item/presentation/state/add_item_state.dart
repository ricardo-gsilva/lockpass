import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

class AddItemState {
  final bool isFormValid;
  final bool obscureText;
  final bool sufixIcon;
  final List<String> listItensDrop;
  final AddItemStatus status;

  const AddItemState({
    this.isFormValid = false,
    this.obscureText = true,
    this.sufixIcon = true,
    this.listItensDrop = const [],
    this.status = const AddItemInitial(),
  });

  AddItemState copyWith({
    bool? isFormValid,
    bool? obscureText,
    bool? sufixIcon,
    List<String>? listItensDrop,
    AddItemStatus? status,
  }) {
    return AddItemState(
      isFormValid: isFormValid ?? this.isFormValid,
      obscureText: obscureText ?? this.obscureText,
      sufixIcon: sufixIcon ?? this.sufixIcon,
      listItensDrop: listItensDrop ?? this.listItensDrop,
      status: status ?? this.status,
    );
  }
}