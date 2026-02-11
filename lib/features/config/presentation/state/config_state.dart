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
  final bool isCheckingPin;
  final String folderName;
  final String selectedFolderPath;
  final bool selectedFolder;
  final String? selectedZipPath;
  final String? selectedZipName;
  final bool hasSelectedZip;
  final bool isRestoring;
  final bool resetPass;
  final String currentPassword;
  final String newPassword;
  final bool updatedPassword;
  final bool saveZip;

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
    this.isCheckingPin = false,
    this.folderName = '',
    this.selectedFolderPath = '',
    this.selectedFolder = false,
    this.selectedZipPath,
    this.selectedZipName,
    this.hasSelectedZip = false,
    this.isRestoring = false,
    this.resetPass = false,
    this.currentPassword = '',
    this.newPassword = '',
    this.updatedPassword = false,
    this.saveZip = false,
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
    bool? isCheckingPin,
    String? folderName,
    bool? selectedFolder,
    String? selectedFolderPath,
    String? selectedZipPath,
    String? selectedZipName,
    bool? hasSelectedZip,
    bool? isRestoring,
    bool? resetPass,
    String? currentPassword,
    String? newPassword,
    bool? updatedPassword,
    bool? saveZip,
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
      isCheckingPin: isCheckingPin ?? this.isCheckingPin,
      folderName: folderName ?? this.folderName,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      selectedFolderPath: selectedFolderPath ?? this.selectedFolderPath,
      selectedZipPath: selectedZipPath ?? this.selectedZipPath,
      selectedZipName: selectedZipName ?? this.selectedZipName,
      hasSelectedZip: hasSelectedZip ?? this.hasSelectedZip,
      isRestoring: isRestoring ?? this.isRestoring,
      resetPass: resetPass ?? this.resetPass,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      updatedPassword: updatedPassword ?? this.updatedPassword,
      saveZip: saveZip ?? this.saveZip,
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
        isCheckingPin,
        folderName,
        selectedFolder,
        selectedFolderPath,
        selectedZipPath,
        selectedZipName,
        hasSelectedZip,
        isRestoring,
        resetPass,
        currentPassword,
        newPassword,
        updatedPassword,
        saveZip,
      ];
}
