import 'package:lockpass/constants/core_strings.dart';
extension StringValidators on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrBlank => !isNullOrBlank;

  String get trimmed => (this ?? '').trim();

  String? get requiredError {
    return isNullOrBlank ? CoreStrings.fieldRequired : null;
  }

  bool get isValidEmail {
    final text = trimmed;
    if (text.isEmpty) return false;
    final regex = RegExp(CoreStrings.regExpValidateEmail);
    return regex.hasMatch(text);
  }

  String? get emailError {
    if (isNullOrBlank) return "O e-mail é obrigatório";
    if (!isValidEmail) return "E-mail inválido";
    return null;
  }

  String? get passwordError {
    if (isNullOrBlank) return "A senha é obrigatória";
    if (this!.length < 6) return "Mínimo de 6 caracteres";
    return null;
  }
}
