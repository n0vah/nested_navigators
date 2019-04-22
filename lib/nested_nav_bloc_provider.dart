import 'package:flutter/material.dart';
import 'package:nested_navigators/nested_nav_bloc.dart';
import 'package:nested_navigators/nested_navigators.dart';

/// A widget that contains [NestedNavigatorsBloc] and provides access to this bloc by its children by calling the static method [NestedNavigatorsBlocProvider.of].
///
/// For example:
/// ```dart
/// NestedNavigatorsBlocProvider.of(context).select(NestedNavItemKey.green)
/// ```
class NestedNavigatorsBlocProvider extends StatefulWidget {
  NestedNavigatorsBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  })  : assert(child != null),
        assert(bloc != null),
        super(key: key);

  final NestedNavigatorsBloc bloc;
  final Widget child;

  @override
  State<NestedNavigatorsBlocProvider> createState() =>
      _NestedNavigatorsBlocProviderState();

  /// Return a [NestedNavigatorsBloc] object if [context] from a child of [NestedNavigatorsBlocProvider] or [NestedNavigators].
  static NestedNavigatorsBloc of(BuildContext context) {
    NestedNavigatorsBlocProvider provider =
        context.ancestorWidgetOfExactType(NestedNavigatorsBlocProvider);
    return provider?.bloc;
  }
}

class _NestedNavigatorsBlocProviderState
    extends State<NestedNavigatorsBlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
