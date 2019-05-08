import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';

class MenuButton extends StatelessWidget {
  MenuButton({
    this.endDrawer = false,
    this.icon,
  });

  final Icon icon;
  final bool endDrawer;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? Icon(Icons.menu),
      onPressed: () {
        NestedNavigatorsBlocProvider.of(context)
            .actionWithScaffold((scaffoldState) {
          if (endDrawer) {
            scaffoldState.openEndDrawer();
          } else {
            scaffoldState.openDrawer();
          }
        });
      },
    );
  }
}
