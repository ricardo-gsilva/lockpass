import 'package:lockpass/constants/core_strings.dart';

extension FieldValidators on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String get trimmed => (this ?? '').trim();

  bool get isValidEmail {
    final text = trimmed;
    if (text.isEmpty) return false;
    final regex = RegExp(CoreStrings.regExpValidateEmail);
    return regex.hasMatch(text);
  }

  String? get emailError {
    if (isBlank) return "O e-mail é obrigatório";
    if (!isValidEmail) return "E-mail inválido";
    return null;
  }

  String? get passwordError {
    if (isBlank) return "A senha é obrigatória";
    if (this!.length < 6) return "Mínimo de 6 caracteres";
    return null;
  }
}
