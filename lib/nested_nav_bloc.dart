import 'dart:async';

import 'package:flutter/material.dart';

class NestedNavigatorsBloc<T> {
  T _selectedNavigatorKey;
  bool _tabBarVisible = true;

  bool get isTabBarVisible => _tabBarVisible;

  T get selectedNavigatorKey => _selectedNavigatorKey;

  final _selectNavigatorController = StreamController<T>.broadcast();

  final _selectNavigatorAndNavigateController = StreamController<
      MapEntry<T, Function(NavigatorState navigator)>>.broadcast();

  final _tabBarVisibilityController = StreamController<bool>.broadcast();

  Stream<T> get outSelectTab => _selectNavigatorController.stream;

  Stream<MapEntry<T, Function(NavigatorState navigator)>>
      get outSelectTabAndNavigate =>
          _selectNavigatorAndNavigateController.stream;

  Stream<bool> get outTabBarVisibility => _tabBarVisibilityController.stream;

  /// Select nested navigator
  select(T key) {
    if (key != _selectedNavigatorKey) {
      _selectedNavigatorKey = key;
      _selectNavigatorController.sink.add(key);
    }
  }

  /// Select nested navigator and do navigation transaction in selected navigator
  selectAndNavigate(T key, Function(NavigatorState navigator) transaction) {
    select(key);
    _selectNavigatorAndNavigateController.add(MapEntry(key, transaction));
  }

  setTabBarVisibility(bool visible) {
    if (visible != _tabBarVisible) {
      _tabBarVisible = visible;
      _tabBarVisibilityController.sink.add(visible);
    }
  }

  void dispose() {
    _selectNavigatorController.close();
    _selectNavigatorAndNavigateController.close();
    _tabBarVisibilityController.close();
  }
}
