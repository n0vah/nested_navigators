import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:nested_navigators/nested_navigators.dart';
import 'package:nested_navigators_example/argument_keys.dart';
import 'package:nested_navigators_example/nested_nav_item_key.dart';
import 'package:nested_navigators_example/routes.dart';

class RedPage extends StatelessWidget {
  final int value;

  RedPage({this.value = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !_isMobile && value == 0 ? MenuButton() : null,
        title: Text(
          "Red",
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                value.toString(),
                style: TextStyle(fontSize: 44, color: Colors.white),
              ),
              _divider(),
              _item(
                text: "open new page",
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.red, arguments: {
                    ArgumentKeys.value: value + 1,
                  });
                },
              ),
              _divider(),
              _item(
                text: "open new page and replace",
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.red, arguments: {
                    ArgumentKeys.value: value + 1,
                  });
                },
              ),
              _divider(),
              _item(
                text: "open new page and remove until first",
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.red, (route) => route.isFirst,
                      arguments: {
                        ArgumentKeys.value: value + 1,
                      });
                },
              ),
              _divider(),
              _item(
                text: "open new page and hide tab bar",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Routes.red,
                    arguments: {
                      ArgumentKeys.value: value + 1,
                      hideNavTabBar: true,
                    },
                  );
                },
              ),
              _divider(),
              _item(
                text: "select blue tab",
                onPressed: () {
                  NestedNavigatorsBlocProvider.of(context)
                      .select(NestedNavItemKey.blue);
                },
              ),
              _divider(),
              _item(
                text: "select green tab",
                onPressed: () => NestedNavigatorsBlocProvider.of(context)
                    .select(NestedNavItemKey.green),
              ),
              _divider(),
              _item(
                text: "select green tab and open new page 100",
                onPressed: () {
                  NestedNavigatorsBlocProvider.of(context).selectAndNavigate(
                      NestedNavItemKey.green,
                      (navigator) => navigator.pushNamed(
                            Routes.green,
                            arguments: {
                              ArgumentKeys.value: 100,
                            },
                          ));
                },
              ),
              _divider(),
              _item(
                text: "open new page in root navigator",
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    Routes.red,
                    arguments: {
                      ArgumentKeys.value: value + 1,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isMobile => Platform.isIOS || Platform.isAndroid;

  _item({String text, Function() onPressed}) => FlatButton(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
        onPressed: onPressed,
      );

  _divider() => Flexible(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          height: 2,
        ),
      );
}
