import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  MenuButton({
    @required this.context,
    this.endDrawer = false,
    this.icon,
  });

  final Icon icon;
  final bool endDrawer;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return IconButton(
      icon: icon ?? Icon(Icons.menu),
      onPressed: () {
        if (endDrawer) {
          Scaffold.of(context).openEndDrawer();
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
    );
  }
}
