import 'package:flutter/material.dart';
import 'package:module_app/views/details/details_view.dart';
import 'package:module_app/views/splash/splash_view.dart';

class RouteUtil {
  RouteUtil._();
  static final RouteUtil instance = RouteUtil._();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
      case '/details':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => DetailsView(id: args?['id']),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
    }
  }
}
