import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/task_model.dart';
import '../blocs/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/gradient_touchable_container.dart';

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _searchBoxHeight = 50.0;

  final HomeBloc bloc = HomeBloc();
  String avatarUrl;
  String userDisplayName;

  @override
  initState() {
    super.initState();
    bloc.fetchTasks();
    setUserAttributes();
  }

  Future<void> setUserAttributes() async {
    final url = await bloc.getUserAvatarUrl();
    final name = await bloc.getUserDisplayName();
    setState(() {
      avatarUrl = url;
      userDisplayName = name;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        avatarUrl: avatarUrl,
        subtitle: 'Hello $userDisplayName!',
      ),
      body: StreamBuilder(
        stream: bloc.userTasks,
        builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snap) {
          if (!snap.hasData) {
            return Center(
              child: LoadingIndicator(),
            );
          }
          return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildTasksList(snap.data),
              // This container is needed to make it seem like the search box is
              // part of the app bar.
              Container(
                height: _searchBoxHeight / 2,
                width: double.infinity,
                color: Theme.of(context).cardColor,
              ),
              buildSearchBox(),
            ],
          );
        },
      ),
    );
  }

  Widget buildTasksList(List<TaskModel> tasks) {
    return ListView(
      padding: EdgeInsets.only(top: _searchBoxHeight + 15),
      children: tasks
          .map((task) => Container(
                child: TaskListTile(
                  task: task,
                  onDone: () => bloc.markTaskAsDone(task),
                ),
                padding: EdgeInsets.only(bottom: 12),
              ))
          .toList(),
    );
  }

  Widget buildSearchBox() {
    return Row(
      children: <Widget>[
        Spacer(flex: 1),
        Expanded(
          flex: 8,
          child: GradientTouchableContainer(
            radius: _searchBoxHeight / 2,
            height: _searchBoxHeight,
            shadow: BoxShadow(
              color: Color(0x20FFFFFF),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Icon(
                  FontAwesomeIcons.sistrix,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    cursorColor: Colors.white,
                    scrollPadding: EdgeInsets.zero,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
