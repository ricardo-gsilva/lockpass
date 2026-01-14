import 'package:flutter/widgets.dart';
import 'package:lockpass/features/splash/presentation/pages/splash_screen_page.dart';
import 'package:lockpass/screens/add_item.dart';
import 'package:lockpass/screens/card_item.dart';
import 'package:lockpass/screens/config.dart';
import 'package:lockpass/screens/create_user.dart';
import 'package:lockpass/screens/home_page.dart';
import 'package:lockpass/screens/login_page.dart';

class AppRoutes {
  static const splash = '/splashScreen';
  static const login = '/login';
  static const home = '/home';
  static const createUser = '/createUser';
  static const addItem = '/addItem';
  static const config = '/config';
  static const cardItem = '/cardItem';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreenPage(),
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    createUser: (_) => const CreateUserPage(),
    addItem: (_) => const AddItemPage(),
    config: (_) => const ConfigPage(),
    cardItem: (_) => const CardItemPage(),
  };
}