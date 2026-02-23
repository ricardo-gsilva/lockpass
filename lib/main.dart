
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/session/presentation/page/app_lifecycle_wrapper.dart';
import 'package:lockpass/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupGetIt();
  runApp(const MainLockPass());
}

class MainLockPass extends StatelessWidget {
  const MainLockPass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRoutes.navigatorKey,
      title: CoreStrings.appName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return AppLifecycleWrapper(child: child!);
      },
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}