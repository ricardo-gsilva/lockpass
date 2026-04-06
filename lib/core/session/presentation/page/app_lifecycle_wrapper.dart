import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
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
  late final AuthService _authService;
  bool _obscureApp = false;
  DateTime? _backgroundedAt;
  Timer? _idleTimer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _sessionLock = getIt<SessionLockService>();
    _authService = getIt<AuthService>();
    WidgetsBinding.instance.addObserver(this);
    _getLockTimeout = getIt<GetLockTimeoutSessionUseCase>();
    seconds = _getLockTimeout();
    _resetIdleTimer();
  }

  bool get _isAuthenticated => _authService.currentUser != null;

  String? _currentRouteName() {
    final navigatorState = AppRoutes.navigatorKey.currentState;
    if (navigatorState == null) return null;

    String? currentRouteName;
    navigatorState.popUntil((route) {
      currentRouteName = route.settings.name;
      return true;
    });
    return currentRouteName;
  }

  bool _isPublicStage([String? routeName]) {
    // Regra: em splash/login nunca deve bloquear, independente de auth state.
    final name = routeName ?? _currentRouteName();
    return name == null || name == AppRoutes.splash || name == AppRoutes.login;
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
          if (!_isPublicStage() && _isAuthenticated && seconds > 0 && elapsed >= lockThreshold) {
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
      if (!_isPublicStage() && _isAuthenticated) {
        _sessionLock.lock();
        _handleLockNavigation();
      }
    });
  }

  void _handleLockNavigation() {
    final navigatorState = AppRoutes.navigatorKey.currentState;
    if (navigatorState == null) return;

    final currentRouteName = _currentRouteName();

    final bool isAtPublicStage = _isPublicStage(currentRouteName);

    final bool isAlreadyAtLock = currentRouteName == AppRoutes.lockScreen;

    // Regra: em splash/login nunca deve bloquear, independente de auth state.
    if (isAtPublicStage) return;

    // A tela de proteção só faz sentido após login; no pré-login não deve bloquear a UX.
    if (!_isAuthenticated) return;

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
