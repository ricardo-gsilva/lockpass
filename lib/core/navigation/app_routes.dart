import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/pages/home_page.dart';
import 'package:lockpass/features/login/presentation/pages/login_page.dart';
import 'package:lockpass/features/splash/presentation/pages/splash_screen_page.dart';
import 'package:lockpass/screens/add_item.dart';
import 'package:lockpass/screens/card_item.dart';
import 'package:lockpass/screens/create_user.dart';

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
    login: (_) => const LoginPage1(),
    home: (_) => BlocProvider(
      create: (_) => getIt<HomeController>(),
      child: const HomePage1()),
    createUser: (_) => const CreateUserPage(),
    addItem: (_) => const AddItemPage(),
    config: (_) => const ConfigPage1(),
    cardItem: (_) => const CardItemPage(),
  };
}