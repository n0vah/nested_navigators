# NestedNavigators

Flutter widget to implement multiple stacks routes.

# Usage
To use, you must at least specify two arguments **items** and **generateRoute**:
```dart
class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return NestedNavigators(
      items: {
        NestedNavItemKey.blue: NestedNavigatorItem(
          initialRoute: Routes.blue,
          icon: Icons.access_time,
          text: "Blue",
        ),
        NestedNavItemKey.red: NestedNavigatorItem(
          initialRoute: Routes.red,
          icon: Icons.send,
          text: "Red",
        ),
        NestedNavItemKey.green: NestedNavigatorItem(
          initialRoute: Routes.green,
          icon: Icons.perm_identity,
          text: "Green",
        ),
      },
      generateRoute: Routes.generateRoute,
    );
  }
}
```
See [Routes.generateRoute()](https://github.com/n0vah/nested_navigators/blob/master/example/lib/routes.dart)

By default **NestedNavigators** displays *BottomNavigationBar*, but you can hide it if you want:
```dart
clearStackAfterTapOnCurrentTab: false
 ```
 You can customize *BottomNavigatosBar* items in two ways:
 - configure BottomNavigationBarItem:
 ```dart
buildBottomNavigationItem: (key, item, selected) => BottomNavigationBarItem(
            icon: Icon(
              item.icon,
              color: Colors.blue,
            ),
            title: Text(
              item.text,
              style: TextStyle(fontSize: 20),
            ),
          )
```
 - Define your own widget:
```dart
buildCustomBottomNavigationItem: (key, item, selected) => Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  item.icon,
                  size: 24,
                  color: selected ? Colors.blue : null,
                ),
                Text(
                  item.text,
                  style: TextStyle(fontSize: 20, color: selected ? Colors.blue : null),
                ),
              ],
            ),
          )
```
Initial selected navigator:
- If number of navigators is even number, than it will be the first elemnt of **items**;
- If number of navigators is odd number, than it will be the middle element of **items**;
- You can specify your navigator key:
```dart
 initialNavigatorKey: NestedNavItemKey.green
 ```
 You can specify the color of ripple effect in your app theme or in *bottomNavigationBarTheme*:
 ```dart
bottomNavigationBarTheme: Theme.of(context).copyWith(
        splashColor: Colors.blue[100],
    )
```
By default, if a user clicks on an already selected tab item, the route stack will be cleared and the initial route will be displayed. You can disable this option:
```dart
clearStackAfterTapOnCurrentTab: false
```
When you navigate to another route within nested navigator, you can hide *BottomNavigatorsBar* for specific route, just add **hideNavTabBar: true** to route arguments:
```dart
 Navigator.of(context).pushNamed(
                    Routes.red,
                    arguments: {
                      hideNavTabBar: true,
                    },
                  );
```
You can select another navigator from your routes:
```dart
NestedNavigatorsBlocProvider.of(context).select(NestedNavItemKey.green)
```
You can also switch displayed navigator and at the same time make navigation in the new navigator:
```dart
NestedNavigatorsBlocProvider.of(context).selectAndNavigate(
                      NestedNavItemKey.green,
                      (navigator) => navigator.pushNamed(
                            Routes.green,
                            arguments: {
                              ArgumentKeys.value: 100,
                            },
                          ));
```
Add NestedNavigatorsBlocProvider to app widget if you want to use the root navigator and need access to nested navigators from there:
```dart
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final NestedNavigatorsBloc _bloc = NestedNavigatorsBloc<NestedNavItemKey>();

  @override
  Widget build(BuildContext context) {
    return NestedNavigatorsBlocProvider(
      bloc: _bloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: RootPage(),
        onGenerateRoute: (routeSettings) => Routes.generateRoute(routeSettings),
      ),
    );
  }
}
```
