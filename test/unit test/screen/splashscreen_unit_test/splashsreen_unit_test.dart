import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/stores/splash_screen_store.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/package_info');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channel.name, (data) async {
    final MethodCall call = channel.codec.decodeMethodCall(data);
    if (call.method == 'getAll') {
      return channel.codec.encodeSuccessEnvelope(<String, dynamic>{
        'appName': '...',
        'packageName': '...',
        'version': '1.0.0',
        'buildNumber': '1'
      });
    }
    return null;
  });
  test('Receives a string with the app version', () async {
    final splashStore = SplashScreenStore();
    await splashStore.getVersion();

    expect(splashStore.packageInfo?.version, '1.0.0');
  });
}