import 'package:flutter/material.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;
  const AppLifecycleWrapper({super.key, required this.child});

  @override
  State<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  late final SessionLockService _sessionLock;

  @override
  void initState() {
    super.initState();
    _sessionLock = getIt<SessionLockService>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _sessionLock.lock();
    }

    if (state == AppLifecycleState.resumed) {
      _handleLockNavigation();
    }
  }

  void _handleLockNavigation() {
    final navigatorState = AppRoutes.navigatorKey.currentState;
    if (navigatorState == null) return;

    String? currentRouteName;
    navigatorState.popUntil((route) {
      currentRouteName = route.settings.name;
      return true;
    });

    final bool isAtPublicStage = currentRouteName == AppRoutes.splash ||
        currentRouteName == AppRoutes.login;

    final bool isAlreadyAtLock = currentRouteName == AppRoutes.lockScreen;

    if (_sessionLock.isLocked && !isAtPublicStage && !isAlreadyAtLock) {
      navigatorState.pushNamed(AppRoutes.lockScreen);
    }
  }

  // void _handleLockNavigation() {
  //   final navigatorState = AppRoutes.navigatorKey.currentState;
  //   if (navigatorState == null) return;

  //   String? currentRouteName;
  //   navigatorState.popUntil((route) {
  //     currentRouteName = route.settings.name;
  //     return true;
  //   });

  //   final bool isAtPublicStage = currentRouteName == AppRoutes.splash ||
  //       currentRouteName == AppRoutes.login;

  //   if (_sessionLock.isLocked &&
  //       !_sessionLock.isNavigationInProgress &&
  //       !isAtPublicStage) {
  //     _sessionLock.setNavigationInProgress(true);
  //     navigatorState.pushNamed(AppRoutes.lockScreen);
  //   }
  // }

  @override
  Widget build(BuildContext context) => widget.child;
}
