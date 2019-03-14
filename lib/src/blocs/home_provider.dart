import 'package:flutter/material.dart';

import './home_bloc.dart';
export './home_bloc.dart';

class HomeProvider extends InheritedWidget {
  final HomeBloc bloc;

  HomeProvider({
    Key key,
    Widget child,
  })  : bloc = HomeBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(HomeProvider) as HomeProvider)
        .bloc;
  }
}
