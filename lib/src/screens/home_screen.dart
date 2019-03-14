import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../blocs/home_bloc.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc bloc = HomeBloc();

  @override
  initState() {
    super.initState();
    bloc.fetchTasks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        child: StreamBuilder(
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
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
