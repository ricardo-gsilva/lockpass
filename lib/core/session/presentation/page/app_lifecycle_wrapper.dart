import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;
  const AppLifecycleWrapper({super.key, required this.child});

  @override
  State<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper> with WidgetsBindingObserver {
  late final SessionLockService _sessionLock;
  late final GetLockTimeoutSessionUseCase _getLockTimeout;
  bool _obscureApp = false;
  DateTime? _backgroundedAt;
  Timer? _idleTimer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _sessionLock = getIt<SessionLockService>();
    WidgetsBinding.instance.addObserver(this);
    _getLockTimeout = getIt<GetLockTimeoutSessionUseCase>();
    seconds = _getLockTimeout();
    _resetIdleTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _idleTimer?.cancel();
        _backgroundedAt ??= DateTime.now();

        if (mounted && !_obscureApp) {
          setState(() => _obscureApp = true);
        }
        break;
      case AppLifecycleState.resumed:
        seconds = _getLockTimeout();
        _resetIdleTimer();
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;

        if (mounted && _obscureApp) {
          setState(() => _obscureApp = false);
        }

        if (backgroundedAt != null) {
          final lockThreshold = Duration(seconds: seconds);
          final elapsed = DateTime.now().difference(backgroundedAt);
          if (seconds > 0 && elapsed >= lockThreshold) {
            _sessionLock.lock();
          }
        }
        _handleLockNavigation();
        break;
      default:
        break;
    }
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    if (seconds <= 0) return;

    _idleTimer = Timer(Duration(seconds: seconds), () {
      _sessionLock.lock();
      _handleLockNavigation();
    });
  }

  void _handleLockNavigation() {
    final navigatorState = AppRoutes.navigatorKey.currentState;
    if (navigatorState == null) return;

    String? currentRouteName;
    navigatorState.popUntil((route) {
      currentRouteName = route.settings.name;
      return true;
    });

    final bool isAtPublicStage = currentRouteName == AppRoutes.splash || currentRouteName == AppRoutes.login;

    final bool isAlreadyAtLock = currentRouteName == AppRoutes.lockScreen;

    if (_sessionLock.isLocked && !isAtPublicStage && !isAlreadyAtLock) {
      navigatorState.pushNamed(AppRoutes.lockScreen);
    }
  }

  Widget _childNotification() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _resetIdleTimer();
        return false;
      },      
      child: Listener(
        onPointerDown: (_) => _resetIdleTimer(),
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_obscureApp) {
      return _childNotification();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _childNotification(),
        const ColoredBox(
          color: CoreColors.black,
        ),
      ],
    );
  }
}