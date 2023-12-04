
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/firebase_options.dart';
import 'package:lockpass/screens/add_item.dart';
import 'package:lockpass/screens/card_item.dart';
import 'package:lockpass/screens/config.dart';
import 'package:lockpass/screens/create_user.dart';
import 'package:lockpass/screens/home_page.dart';
import 'package:lockpass/screens/login_page.dart';
import 'package:lockpass/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'LockPass',
      debugShowCheckedModeBanner: false,
      routes: {
        '/splashScreen': (_) => const SplashScreenPage(),
        '/login': (_) => const LoginPage(),
        '/home':(_) => const HomePage(),
        '/createUser': (_) => const CreateUser(),
        '/addItem': (_) => const AddItem(),
        '/config': (_) => const Config(),
        '/cardItem':(_) => const CardItem()
      },
      initialRoute: '/splashScreen',
    );
  }
}