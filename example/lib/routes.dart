import 'package:flutter/material.dart';

import 'argument_keys.dart';
import 'pages/blue_page.dart';
import 'pages/green_page.dart';
import 'pages/red_page.dart';

class Routes {
  Routes._();

  static const root = '/';
  static const red = '/red';
  static const blue = '/blue';
  static const green = '/green';

  static MaterialPageRoute generateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) => _buildPage(routeSettings.name, routeSettings.arguments),
    );
  }

  static Widget _buildPage(String name, Object arguments) {
    Map<String, dynamic> argumentsMap = arguments is Map<String, dynamic> ? arguments : Map();
    switch (name) {
      case blue:
        return BluePage(
          value: arguments ?? 0,
        );
      case red:
        return RedPage(
          value: argumentsMap[ArgumentKeys.value] ?? 0,
        );
      case green:
        return GreenPage(
          value: argumentsMap[ArgumentKeys.value] ?? 0,
        );
      default:
        return Container();
    }
  }
}
