import 'package:flutter/material.dart' hide AppBar;

import '../blocs/archive_bloc.dart';
import '../models/task_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/populated_drawer.dart';
import '../widgets/task_list_tile.dart';

class ArchiveScreen extends StatefulWidget {
  _ArchiveScreenstate createState() => _ArchiveScreenstate();
}

class _ArchiveScreenstate extends State<ArchiveScreen> {
  final bloc = ArchiveBloc();

  initState() {
    super.initState();
    bloc.fetchTasks();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (context, AsyncSnapshot<FirebaseUser> userSnap) {
        String userAvatarUrl, userDisplayName = '', userEmail = '';

        if (userSnap.hasData) {
          userAvatarUrl = userSnap.data.photoUrl;
          userDisplayName = userSnap.data.displayName;
          userEmail = userSnap.data.email;
        }

        return Scaffold(
          drawer: PopulatedDrawer(
            userAvatarUrl: userAvatarUrl,
            userDisplayName: userDisplayName,
            userEmail: userEmail,
            selectedScreen: Screen.archive,
          ),
          appBar: AppBar(
            title: 'Archive',
            hasDrawer: true,
          ),
          body: StreamBuilder(
            stream: bloc.tasks,
            builder: (context, AsyncSnapshot<List<TaskModel>> tasksSnap) {
              if (!tasksSnap.hasData) {
                return Center(
                  child: LoadingIndicator(),
                );
              }

              return buildList(tasksSnap.data);
            },
          ),
        );
      },
    );
  }

  Widget buildList(List<TaskModel> tasks) {
    return ListView(
      padding: EdgeInsets.only(top: 15),
      children: tasks
          .map(
            (task) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: TaskListTile(
                    task: task,
                    onUndo: () => bloc.undoTask(task),
                  ),
                ),
          )
          .toList(),
    );
  }
}
