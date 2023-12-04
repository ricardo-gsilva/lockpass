import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/splash_screen.dart';
import 'package:lockpass/widgets/text_custom.dart';

void main(){
  group('Looking for splashscreen widgets', () {    

    testWidgets('Looking for widget with app icon', (test) async {
      await test.pumpWidget(
        const MaterialApp(
          home: SplashScreenPage(),
        )
      );
      
      final finderIconApp = find.byKey(CoreKeys.iconAppSplashScreen);
      expect(finderIconApp, findsOneWidget);

      final SizedBox sized = test.widget(finderIconApp); 
      expect(sized.height, 200);
      expect(find.image(const AssetImage(CoreStrings.iconApp)), findsOneWidget);      
    });

    testWidgets('Looking for widget with app name', (test) async {
      await test.pumpWidget(
        const MaterialApp(
          home: SplashScreenPage(),
        )
      );
    
      final finderText = find.byKey(CoreKeys.textAppNameSplashScreen);

      expect(finderText, findsWidgets);

      final TextCustom text = test.widget(finderText);
      expect(text.color, CoreColors.textSecundary);
      expect(text.fontSize, 24);
      expect(text.text, CoreStrings.appName);

    });

    testWidgets('Looking for the splashscreen loading widget', (test) async {
      await test.pumpWidget(
        const MaterialApp(
          home: SplashScreenPage(),
        )
      );

      final finderProgressIndicator = find.byKey(CoreKeys.circularProgressSplashScreen);
      expect(finderProgressIndicator, findsOneWidget);

      final CircularProgressIndicator finderCircularProgress = test.widget(finderProgressIndicator);
      expect(finderCircularProgress.color, CoreColors.textTertiary);
    });

    testWidgets('Looking for the widget that informs the app version', (test) async {
      await test.pumpWidget(
        const MaterialApp(
          home: SplashScreenPage(),
        )
      );

      final finderAppVersion = find.byKey(CoreKeys.appVersionSplashScreen);
      expect(finderAppVersion, findsOneWidget);

      final TextCustom textAppVersion = test.widget(finderAppVersion);
      expect(textAppVersion.color, CoreColors.textSecundary);
      expect(textAppVersion.fontSize, 16);
    });
  });
  
}