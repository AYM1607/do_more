import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../blocs/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          return ListView(
            padding: EdgeInsets.zero,
            children: snap.data
                .map((task) => Container(
                      child: TaskListTile(
                        task: task,
                        onDone: () => bloc.markTaskAsDone(task),
                      ),
                      padding: EdgeInsets.only(bottom: 12),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
