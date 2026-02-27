import 'package:equatable/equatable.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class ConfigState extends Equatable {
  final ConfigStatus status;
  final bool hasPin;
  final bool isAndroid;

  const ConfigState({
    this.status = const ConfigInitial(),
    this.hasPin = false,
    this.isAndroid = true,
  });

  ConfigState copyWith({
    ConfigStatus? status,
    bool? hasPin,
    bool? isAndroid,
  }) {
    return ConfigState(
      status: status ?? this.status,
      hasPin: hasPin ?? this.hasPin,
      isAndroid: isAndroid ?? this.isAndroid,
    );
  }

  @override
  List<Object?> get props => [status, hasPin, isAndroid];
}