import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:nested_navigators/nested_navigators.dart';

class NestedNavigatorItem {
  NestedNavigatorItem({
    @required this.initialRoute,
    this.icon,
    this.text,
  }) {
    _navigatorObserver = _NestedNavigatorObserver(_navigatorKey);
    _heroController = HeroController(createRectTween: _createRectTween);

    _navigator = new Navigator(
      observers: <NavigatorObserver>[_navigatorObserver, _heroController],
      key: _navigatorKey,
      onGenerateRoute: (routeSettings) => routeSettings.name == _rootRouteName
          ? generateRoute(RouteSettings(
              name: initialRoute, arguments: routeSettings.arguments))
          : generateRoute(routeSettings),
    );
  }

  static const _rootRouteName = "/";
  final IconData icon;
  final String text;
  final String initialRoute;
  final _navigatorKey = GlobalKey<NavigatorState>();
  Navigator _navigator;
  _NestedNavigatorObserver _navigatorObserver;
  HeroController _heroController;
  Function(RouteSettings routeSettings) generateRoute;

  Navigator get navigator => _navigator;

  NavigatorState get navigatorState => _navigatorKey.currentState;

  bool get navTabBarVisible => _navigatorObserver.navTabBarVisible;

  RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
}

class _NestedNavigatorObserver extends NavigatorObserver {
  final GlobalKey<NavigatorState> _navigatorKey;
  bool navTabBarVisible = true;

  _NestedNavigatorObserver(this._navigatorKey);

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    updateNavTabBarVisibility(newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    updateNavTabBarVisibility(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    updateNavTabBarVisibility(route, previousRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    updateNavTabBarVisibility(route, previousRoute);
  }

  void updateNavTabBarVisibility(
      Route<dynamic> route, Route<dynamic> previousRoute) {
    Map<String, dynamic> arguments = Map();
    if (route != null &&
        route.isCurrent &&
        route.settings.arguments is Map<String, dynamic>) {
      arguments.addAll(route.settings.arguments);
    } else if (previousRoute != null &&
        previousRoute.isCurrent &&
        previousRoute.settings.arguments is Map<String, dynamic>) {
      arguments.addAll(previousRoute.settings.arguments);
    }

    navTabBarVisible = !(arguments[hideNavTabBar] ?? false);

    final bloc =
        NestedNavigatorsBlocProvider.of(_navigatorKey.currentState.context);
    bloc.setTabBarVisibility(navTabBarVisible);
  }
}
