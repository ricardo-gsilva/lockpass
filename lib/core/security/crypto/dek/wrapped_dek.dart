class WrappedDek {
  final String saltB64;
  final String nonceB64;
  final String ciphertextB64;

  const WrappedDek({
    required this.saltB64,
    required this.nonceB64,
    required this.ciphertextB64,
  });

  Map<String, dynamic> toJson() => {
    'saltB64': saltB64,
    'nonceB64': nonceB64,
    'ciphertextB64': ciphertextB64,
  };

  factory WrappedDek.fromJson(Map<String, dynamic> json) => WrappedDek(
    saltB64: json['saltB64'] as String,
    nonceB64: json['nonceB64'] as String,
    ciphertextB64: json['ciphertextB64'] as String,
  );
}