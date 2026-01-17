import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/login/presentation/pages/login_page.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:lockpass/widgets/text_custom.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      // Navigator.of(context).popAndPushNamed(CoreStrings.loginPage);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage1()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashController()..loadPackageInfo(),
      child: Scaffold(
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
                    child: BlocBuilder<SplashController, SplashState>(
                      builder: (context, state) {
                        return TextCustom(
                          key: CoreKeys.appVersionSplashScreen,
                          text: 'v${state.packageInfo?.version ?? ''}',
                          fontSize: 16,
                          color: CoreColors.textSecundary,
                        );
                      },
                    ),                    
                  ),
                ),
              ],
            )          
          ],
        ),
      ),
    );
  }
}
