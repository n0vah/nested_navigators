import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:nested_navigators/nested_navigators.dart';
import 'package:nested_navigators_example/nested_nav_item_key.dart';
import 'package:nested_navigators_example/routes.dart';

class BluePage extends StatelessWidget {
  final int value;

  BluePage({this.value = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !_isMobile && value == 0 ? MenuButton() : null,
        title: Text(
          "Blue",
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      body: Container(
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
                Navigator.of(context).pushNamed(
                  Routes.blue,
                  arguments: value + 1,
                );
              },
            ),
            _divider(),
            _item(
              text: "select red tab",
              onPressed: () {
                final bloc = NestedNavigatorsBlocProvider.of(context);
                bloc.select(NestedNavItemKey.red);
              },
            ),
            _divider(),
            _item(
              text: "select green tab",
              onPressed: () {
                NestedNavigatorsBlocProvider.of(context)
                    .select(NestedNavItemKey.green);
              },
            ),
            _divider(),
            _item(
              text: "open left drawer",
              onPressed: () {
                NestedNavigatorsBlocProvider.of(context).actionWithScaffold(
                  (scaffoldState) => scaffoldState.openDrawer(),
                );
              },
            ),
            _divider(),
            _item(
              text: "open right drawer",
              onPressed: () {
                NestedNavigatorsBlocProvider.of(context).actionWithScaffold(
                  (scaffoldState) => scaffoldState.openEndDrawer(),
                );
              },
            ),
          ],
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
