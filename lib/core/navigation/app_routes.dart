import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/session/presentation/page/lock_screen_page.dart';
import 'package:lockpass/features/add_item/presentation/page/add_item_page.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/pages/home_page.dart';
import 'package:lockpass/features/list_item/presentation/page/list_item_page.dart';
import 'package:lockpass/features/login/presentation/pages/login_page.dart';
import 'package:lockpass/features/splash/presentation/pages/splash_screen_page.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const splash = '/splashScreen';
  static const login = '/login';
  static const home = '/home';
  static const createUser = '/createUser';
  static const addItem = '/addItem';
  static const config = '/config';
  static const cardItem = '/cardItem';
  static const lockScreen = '/lockScreen';
  static const listItem = '/listItem';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreenPage(),
    login: (_) => const LoginPage(),
    home: (_) => BlocProvider(
      create: (_) => getIt<HomeController>(),
      child: const HomePage()),
    addItem: (_) => const AddItemPage(),
    config: (_) => const ConfigPage(),
    lockScreen: (_) => const LockScreenPage(),
    listItem: (_) => const ListItemPage()
  };
}