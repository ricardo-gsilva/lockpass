import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/splash_screen_store.dart';
import 'package:lockpass/widgets/text_custom.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SplashScreenStore store = SplashScreenStore();

  @override
  void initState() {
    store.getVersion();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).popAndPushNamed(CoreStrings.nLogin);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColors.primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox(
                  key: CoreKeys.iconAppSplashScreen,
                  height: 200,
                  child: Image.asset(CoreStrings.iconApp),
                ),
                const TextCustom(
                  key: CoreKeys.textAppNameSplashScreen,
                  text: CoreStrings.appName,
                  fontSize: 24,
                  color: CoreColors.textSecundary,
                ),
              ],
            ),
          ),
          Flex(
            mainAxisAlignment: MainAxisAlignment.end,
            direction: Axis.vertical,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(
                    key: CoreKeys.circularProgressSplashScreen,
                    color: CoreColors.textTertiary,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Observer(
                    builder: (context) {
                      return TextCustom(
                        key: CoreKeys.appVersionSplashScreen,
                        text: 'v${store.packageInfo?.version?? ''}',
                        fontSize: 16,
                        color: CoreColors.textSecundary,
                      );
                    }
                  ),
                ),
              ),
            ],
          )          
        ],
      ),
    );
  }
}
