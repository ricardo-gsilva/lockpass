
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupGetIt();
  runApp(const MainLockPass());
}

class MainLockPass extends StatelessWidget {
  const MainLockPass({super.key});

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: CoreStrings.appName,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}