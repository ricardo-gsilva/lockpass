import 'package:get_it/get_it.dart';
import 'package:lockpass/core/di/modules/add_item_module.dart';
import 'package:lockpass/core/di/modules/config_module.dart';
import 'package:lockpass/core/di/modules/home_module.dart';
import 'package:lockpass/core/di/modules/list_item_module.dart';
import 'package:lockpass/core/di/modules/login_module.dart';
import 'package:lockpass/core/di/modules/register_core_module.dart';
import 'package:lockpass/core/di/modules/session_module.dart';
import 'package:lockpass/core/di/modules/splash_module.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  await registerCoreModule();  

  registerAddItemModule();
  registerConfigModule();
  registerHomeModule();
  registerListItemModule();
  registerLoginModule();
  registerSplashModule();
  registerSessionModule();
}
