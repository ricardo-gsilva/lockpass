import 'package:lockpass/core/constants/core_strings.dart';

extension StringValidators on String? {
  bool get isNullOrBlank => this?.trim().isEmpty ?? true;

  bool get isNotNullOrBlank => !isNullOrBlank;

  bool get isNull => this == null;

  bool get isNotNull => this != null;

  String get trimmed => (this ?? '').trim();

  String? get requiredError {
    return isNullOrBlank ? CoreStrings.fieldRequired : null;
  }

  bool get isValidEmail {
    final value = trimmed;
    if (value.isEmpty) return false;
    final regex = RegExp(CoreStrings.regExpValidateEmail);
    return regex.hasMatch(value);
  }

  String? get emailError {
    if (isNullOrBlank) return CoreStrings.fillField;
    if (!isValidEmail) return CoreStrings.emailInvalid;
    return null;
  }

  String? get passwordError {
    final value = this?.trim();
    if (value == null) return CoreStrings.passwordRequired;
    if (value.length < 6) return CoreStrings.passwordMinLength;
    return null;
  }

  bool _isSequential(String value) {
    const asc = '0123456789';
    const desc = '9876543210';

    return asc.contains(value) || desc.contains(value);
  }

  bool _hasThreeOrMoreConsecutiveRepeat(String value) {
    int repeatCount = 1;

    for (int i = 1; i < value.length; i++) {
      if (value[i] == value[i - 1]) {
        repeatCount++;
        if (repeatCount >= 3) return true;
      } else {
        repeatCount = 1;
      }
    }

    return false;
  }

  String? get pinError {
    final value = trimmed;

    if (!RegExp(r'^\d{5}$').hasMatch(value)) {
      return CoreStrings.pinMustContain;
    }

    if (_isSequential(value)) {
      return CoreStrings.pinWeak;
    }

    if (_hasThreeOrMoreConsecutiveRepeat(value)) {
      return CoreStrings.pinWeak;
    }

    return null;
  }
}
