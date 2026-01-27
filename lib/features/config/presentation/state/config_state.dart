import 'package:equatable/equatable.dart';

class ConfigState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final String successMessage;
  final bool pinValidate;
  final bool hasPin;
  final bool visibleRemovePin;
  final bool isAndroid;
  final String path;
  final String selectedFileName;
  final bool selectedFile;
  final bool isCrypted;
  final double percent;
  final bool isFormValid;
  final bool obscureText;
  final bool sufixIcon;

  const ConfigState({
    this.isLoading = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.pinValidate = false,
    this.hasPin = false,
    this.visibleRemovePin = false,
    this.isAndroid = true,
    this.path = '',
    this.selectedFileName = '',
    this.selectedFile = false,
    this.isCrypted = false,
    this.percent = 0,
    this.isFormValid = false,
    this.obscureText = false,
    this.sufixIcon = false,
  });

  ConfigState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? pinValidate,
    bool? hasPin,
    bool? visibleRemovePin,
    bool? isAndroid,
    String? path,
    String? selectedFileName,
    bool? selectedFile,
    bool? isCrypted,
    double? percent,
    bool? isFormValid,
    bool? obscureText,
    bool? sufixIcon,
  }) {
    return ConfigState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      pinValidate: pinValidate ?? this.pinValidate,
      hasPin: hasPin ?? this.hasPin,
      visibleRemovePin: visibleRemovePin ?? this.visibleRemovePin,
      isAndroid: isAndroid ?? this.isAndroid,
      path: path ?? this.path,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      selectedFile: selectedFile ?? this.selectedFile,
      isCrypted: isCrypted ?? this.isCrypted,
      percent: percent ?? this.percent,
      isFormValid: isFormValid ?? this.isFormValid,
      obscureText: obscureText ?? this.obscureText,
      sufixIcon: sufixIcon ?? this.sufixIcon,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        successMessage,
        hasPin,
        pinValidate,
        isAndroid,
        path,
        selectedFileName,
        selectedFile,
        isCrypted,
        isFormValid,
        obscureText,
        sufixIcon,
      ];
}
