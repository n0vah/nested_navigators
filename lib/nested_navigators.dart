import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:nested_navigators/nested_nav_item.dart';

export 'nav_drawer.dart';

/// The key for the route argument to be used to hide the [BottomNavigationBar] for this route.
///
/// For example:
/// ```dart
///  Navigator.of(context).pushNamed(
///                    Routes.red,
///                    arguments: {
///                      hideNavTabBar: true,
///                    },
///                  );
/// ```
const hideNavTabBar = "hide_nav_tab_bar";

/// Widget which contains N nested navigators and [BottomNavigationBar] (if [showBottomNavigationBar] is true).
/// For access to nested navigator use as usual [Navigator.of], it will return nested navigator wherein defined current widget.
/// Add argument [hideNavTabBar] = true to route arguments if it should be displayed without bottom navigation bar.
/// [initialNavigatorKey] defined which tab should be selected when app launched.
/// You can select nested navigator using [NestedNavigatorsBloc.select] or [NestedNavigatorsBloc.selectAndNavigate]
class NestedNavigators<T> extends StatefulWidget {
  NestedNavigators({
    @required this.items,
    @required this.generateRoute,
    initialNavigatorKey,
    BottomNavigationBarItem Function(
            T key, NestedNavigatorItem item, bool selected)
        buildBottomNavigationItem,
    this.drawer,
    this.endDrawer,
    this.drawerDragStartBehavior = DragStartBehavior.down,
    this.buildCustomBottomNavigationItem,
    this.bottomNavigationBarTheme,
    this.showBottomNavigationBar = true,
    this.clearStackAfterTapOnCurrentTab = true,
  })  : initialSelectedNavigatorKey = initialNavigatorKey != null
            ? initialNavigatorKey
            : _defaultInitialSelectedNavigatorKey(items.keys),
        this.buildBottomNavigationItem = buildBottomNavigationItem != null
            ? buildBottomNavigationItem
            : _defaultBottomNavigationBarItemBuilder<T>(),
        assert(items.isNotEmpty),
        assert(generateRoute != null) {
    items.forEach((key, item) => item.generateRoute = generateRoute);
  }

  /// Map which contains key (prefer to use enums) and [NestedNavigatorItem] for each nested navigator.
  /// If [NestedNavigators] is a child of your [NestedNavigatorsBlocProvider], then the key type must match the generic type of [NestedNavigatorsBloc].
  ///
  /// For example:
  /// ```dart
  ///  items: {
  ///        NestedNavItemKey.blue: NestedNavigatorItem(
  ///          initialRoute: Routes.blue,
  ///          icon: Icons.access_time,
  ///          text: "Blue",
  ///        ),
  ///        NestedNavItemKey.red: NestedNavigatorItem(
  ///          initialRoute: Routes.red,
  ///          icon: Icons.send,
  ///          text: "Red",
  ///        ),
  ///        NestedNavItemKey.green: NestedNavigatorItem(
  ///          initialRoute: Routes.green,
  ///          icon: Icons.perm_identity,
  ///          text: "Green",
  ///        ),
  ///      }
  /// ```
  final Map<T, NestedNavigatorItem> items;

  /// A method that must return [MaterialPageRoute] for each named route that is used inside nested navigators.
  final MaterialPageRoute Function(RouteSettings routeSettings) generateRoute;

  /// Key of nested navigator which will be selected when app launched and [NestedNavigators] will be added to widget tree
  final T initialSelectedNavigatorKey;

  /// Use this builder to customize [BottomNavigationBarItem] items.
  ///
  /// For example:
  /// ```dart
  ///  buildBottomNavigationItem: (key, item, selected) => BottomNavigationBarItem(
  ///          icon: Icon(
  ///            item.icon,
  ///            color: Colors.blue,
  ///          ),
  ///          title: Text(
  ///            item.text,
  ///            style: TextStyle(fontSize: 20),
  ///          ),
  ///          activeIcon: Icon(
  ///            Icons.star,
  ///            color: Colors.yellow,
  ///          ))
  /// ```
  final BottomNavigationBarItem Function(
    T key,
    NestedNavigatorItem item,
    bool selected,
  ) buildBottomNavigationItem;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from right-to-left ([TextDirection.ltr]) or
  /// left-to-right ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  final Widget Function(
    Map<T, NestedNavigatorItem> items,
    T selectedItemKey,
    Function(T) selectNavigator,
  ) drawer;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from either left-to-right ([TextDirection.ltr]) or
  /// right-to-left ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  final Widget Function(
    Map<T, NestedNavigatorItem> items,
    T selectedItemKey,
    Function(T) selectNavigator,
  ) endDrawer;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used for opening
  /// and closing a drawer will begin upon the detection of a drag gesture.
  /// If set to [DragStartBehavior.down] it will begin when a down event is
  /// first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.down].
  final DragStartBehavior drawerDragStartBehavior;

  /// Use this builder if [BottomNavigationBarItem] is not enough for you, and you want to use your own tab item design.
  ///
  /// For example:
  /// ```dart
  ///  buildCustomBottomNavigationItem: (key, item, selected) => Container(
  ///            height: 60,
  ///            child: Column(
  ///              mainAxisAlignment: MainAxisAlignment.center,
  ///              mainAxisSize: MainAxisSize.min,
  ///              children: <Widget>[
  ///                Icon(
  ///                  item.icon,
  ///                  size: 24,
  ///                  color: selected ? Colors.blue : null,
  ///                ),
  ///                Text(
  ///                  item.text,
  ///                  style: TextStyle(fontSize: 20, color: selected ? Colors.blue : null),
  ///                ),
  ///              ],
  ///            ),
  ///          ),
  ///```
  final Widget Function(
    T key,
    NestedNavigatorItem item,
    bool selected,
  ) buildCustomBottomNavigationItem;

  /// Define your owen theme of bottom navigation bar with splashColor for using different ripple effect color, or selected state icon and text color.
  ///
  /// For example:
  /// ```dart
  /// bottomNavigationBarTheme: Theme.of(context).copyWith(
  ///        splashColor: Colors.blue[100],
  ///        primaryColor: Colors.red,
  ///      ),
  /// ```
  final ThemeData bottomNavigationBarTheme;

  /// Set this argument as false if you want to use [Drawer] instead of [BottomNavigatorBar] for selection nested navigator
  ///
  /// Defaults to true.
  final bool showBottomNavigationBar;

  /// Whether the widget stack should be cleared after clicking on the already selected tab.
  ///
  /// For example, if the currently displayed page is the fifth item in a stack of tab widgets stack,
  /// after clicking on current tab in bottom navigation bar,
  /// the widget stack of the current tab will be cleared and displayed [NestedNavigatorItem.initialRoute].
  ///
  /// Defaults to true.
  final bool clearStackAfterTapOnCurrentTab;

  static BottomNavigationBarItem Function(
          T key, NestedNavigatorItem item, bool selected)
      _defaultBottomNavigationBarItemBuilder<T>() =>
          (key, item, selected) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                title: Text(item.text),
              );

  static T _defaultInitialSelectedNavigatorKey<T>(Iterable<T> keys) {
    int size = keys.length;
    return size % 2 == 0 ? keys.first : keys.elementAt((size / 2).floor());
  }

  @override
  State<NestedNavigators> createState() => _NestedNavigatorsState<T>();
}

class _NestedNavigatorsState<T> extends State<NestedNavigators> {
  NestedNavigatorsBloc<T> _bloc;
  bool _hasBlocProviderInTree = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Map<T, NestedNavigatorItem> get _items => widget.items;

  NavigatorState _getNavigatorState(T key) => _items[key].navigatorState;

  T _getNavigatorKeyByIndex(int index) => _items.keys.toList().elementAt(index);

  int _getNavigatorIndexByKey(T key) => _items.keys.toList().indexOf(key);

  @override
  void initState() {
    super.initState();
    // Check that NestedNavigatorsBlocProvider is already defined in the widget tree,
    // if yes - retrieve NestedNavigatorsBloc from him
    // if not - create a NestedNavigatorsBloc object and then add the NestedNavigatorsBlocProvider as the parent of Scaffold which contains a stack of Navigators
    _bloc = NestedNavigatorsBlocProvider.of(context);
    _hasBlocProviderInTree = _bloc != null;
    if (_bloc == null) {
      _bloc = new NestedNavigatorsBloc<T>();
    }
    _bloc.select(widget.initialSelectedNavigatorKey);

    // Set the bottom navigation bar visibility when nested navigator selected
    // by using NestedNavigatorsBloc.select() or NestedNavigatorsBloc.selectAndNavigate()
    _bloc.outSelectTab.listen(
      (key) => _bloc.setTabBarVisibility(_items[key].navTabBarVisible),
    );

    // Listen queries from widget which was added to widget tree with using root navigator,
    // but which is child of NestedNavigatorsBlocProvider, it's will work when app widget is child of NestedNavigatorsBlocProvider
    _bloc.outSelectTabAndNavigate.listen(
      (entry) => entry.value(_getNavigatorState(entry.key)),
    );

    _bloc.outActionWithScaffold.listen(
      (action) => action(_scaffoldKey.currentState),
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async =>
            !await _getNavigatorState(_bloc.selectedNavigatorKey).maybePop(),
        child: _hasBlocProviderInTree
            ? _buildScaffold()
            : NestedNavigatorsBlocProvider(
                bloc: _bloc,
                child: _buildScaffold(),
              ),
      );

  _buildScaffold() => StreamBuilder<T>(
        stream: _bloc.outSelectTab,
        initialData: _bloc.selectedNavigatorKey,
        builder: (_, snapshot) => Scaffold(
              key: _scaffoldKey,
              drawer: widget.drawer != null
                  ? widget.drawer(
                      _items,
                      _bloc.selectedNavigatorKey,
                      (key) => _bloc.select(key),
                    )
                  : null,
              endDrawer: widget.endDrawer != null
                  ? widget.endDrawer(
                      _items,
                      _bloc.selectedNavigatorKey,
                      (key) => _bloc.select(key),
                    )
                  : null,
              drawerDragStartBehavior: widget.drawerDragStartBehavior,
              body: Stack(
                  children: _items.keys
                      .map((key) => _buildNavigator(key, snapshot.data))
                      .toList()),
              bottomNavigationBar: widget.showBottomNavigationBar
                  ? StreamBuilder<bool>(
                      initialData: true,
                      stream: _bloc.outTabBarVisibility,
                      builder: (_, snapshot) => snapshot.data
                          ? _buildBottomNavigator()
                          : Container(height: 0),
                    )
                  : null,
            ),
      );

  Widget _buildNavigator(T key, T currentKey) => Offstage(
        offstage: currentKey != key,
        child: _items[key].navigator,
      );

  Widget _buildNativeBottomNavigatorBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: getBottomNavigatorBarItems(),
        currentIndex: _getNavigatorIndexByKey(_bloc.selectedNavigatorKey),
        onTap: (index) => _onTabBarItemClick(_getNavigatorKeyByIndex(index)),
      );

  List<BottomNavigationBarItem> getBottomNavigatorBarItems() {
    return _items.entries
        .map(
          (entry) => widget.buildBottomNavigationItem(
                entry.key,
                entry.value,
                _bloc.selectedNavigatorKey == entry.key,
              ),
        )
        .toList();
  }

  Widget _buildCustomBottomNavigatorBar() {
    // The ripple effect should go a bit beyond the widget.
    final rippleEffectRadius =
        MediaQuery.of(context).size.width / _items.length * 1.2 / 2;

    return Material(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: _items.keys
            .map((key) => Expanded(
                  child: InkResponse(
                    child: widget.buildCustomBottomNavigationItem(
                        key, _items[key], _bloc.selectedNavigatorKey == key),
                    onTap: () => _onTabBarItemClick(key),
                    radius: rippleEffectRadius,
                    highlightColor: Colors.transparent,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomNavigator() => Theme(
        data: widget.bottomNavigationBarTheme != null
            ? widget.bottomNavigationBarTheme
            : Theme.of(context),
        child: widget.buildCustomBottomNavigationItem == null
            ? _buildNativeBottomNavigatorBar()
            : _buildCustomBottomNavigatorBar(),
      );

  _onTabBarItemClick(T key) {
    if (_bloc.selectedNavigatorKey == key &&
        widget.clearStackAfterTapOnCurrentTab) {
      _getNavigatorState(key).popUntil((route) => route.isFirst);
    } else {
      _bloc.select(key);
    }
  }
}
