class AddItemState {
  final bool fieldIsValid;
  final bool isFormValid;
  final bool sufixIcon;
  final bool obscureText;
  final List<String> listItens;
  final List<String> listItensDrop;
  final String exception;
  final String message;
  final bool isLoading;
  final bool createdItem;

  const AddItemState({
    this.fieldIsValid = false,
    this.isFormValid = false,
    this.sufixIcon = true,
    this.obscureText = true,
    this.listItens = const [],
    this.listItensDrop = const [],
    this.exception = "",
    this.message = "",
    this.isLoading = false,
    this.createdItem = false,
  });

  AddItemState copyWith({
    bool? fieldIsValid,
    bool? isFormValid,
    bool? sufixIcon,
    bool? obscureText,
    List<String>? listItens,
    List<String>? listItensDrop,
    String? exception,
    String? message,
    bool? isLoading,
    bool? createdItem,
  }) {
    return AddItemState(
      fieldIsValid: fieldIsValid ?? this.fieldIsValid,
      isFormValid: isFormValid ?? this.isFormValid,
      sufixIcon: sufixIcon ?? this.sufixIcon,
      obscureText: obscureText ?? this.obscureText,
      listItens: listItens ?? this.listItens,
      listItensDrop: listItensDrop ?? this.listItensDrop,
      exception: exception ?? this.exception,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      createdItem: createdItem ?? this.createdItem,
    );
  }
}