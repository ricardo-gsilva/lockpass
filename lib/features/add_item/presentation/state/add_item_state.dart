// class AddItemState {
//   final bool isFormValid;
//   final bool sufixIcon;
//   final bool obscureText;
//   final List<String> listItensDrop;
//   final String exception;
//   final String message;
//   final bool isLoading;
//   final bool createdItem;

//   const AddItemState({
//     this.isFormValid = false,
//     this.sufixIcon = true,
//     this.obscureText = true,
//     this.listItensDrop = const [],
//     this.exception = "",
//     this.message = "",
//     this.isLoading = false,
//     this.createdItem = false,
//   });

//   AddItemState copyWith({
//     bool? isFormValid,
//     bool? sufixIcon,
//     bool? obscureText,
//     List<String>? listItensDrop,
//     String? exception,
//     String? message,
//     bool? isLoading,
//     bool? createdItem,
//   }) {
//     return AddItemState(
//       isFormValid: isFormValid ?? this.isFormValid,
//       sufixIcon: sufixIcon ?? this.sufixIcon,
//       obscureText: obscureText ?? this.obscureText,
//       listItensDrop: listItensDrop ?? this.listItensDrop,
//       exception: exception ?? this.exception,
//       message: message ?? this.message,
//       isLoading: isLoading ?? this.isLoading,
//       createdItem: createdItem ?? this.createdItem,
//     );
//   }
// }

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