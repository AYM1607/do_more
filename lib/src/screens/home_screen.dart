import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/task_model.dart';
import '../blocs/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/new_item_dialog_route.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search-box.dart';

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _searchBoxHeight = 50.0;

  final HomeBloc bloc = HomeBloc();

  @override
  initState() {
    super.initState();
    bloc.fetchTasks();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> userSnap) {
        String userAvatarUrl, userDisplayName;

        if (userSnap.hasData) {
          userAvatarUrl = userSnap.data.photoUrl;
          userDisplayName = userSnap.data.displayName;
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesomeIcons.plus),
            backgroundColor: Color(0xFF707070),
            onPressed: () => _showDialog(context),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: HomeAppBar(
            avatarUrl: userAvatarUrl,
            subtitle: 'Hello $userDisplayName!',
          ),
          body: StreamBuilder(
            stream: bloc.userTasks,
            builder:
                (BuildContext context, AsyncSnapshot<List<TaskModel>> snap) {
              if (!snap.hasData) {
                return Center(
                  child: LoadingIndicator(),
                );
              }
              return Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  _buildTasksList(snap.data),
                  // This container is needed to make it seem like the search box is
                  // part of the app bar.
                  Container(
                    height: _searchBoxHeight / 2,
                    width: double.infinity,
                    color: Theme.of(context).cardColor,
                  ),
                  SearchBox(
                    height: 50.0,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    Navigator.of(context).push(NewItemDialogRoute());
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
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
          .toList()
            ..add(Container(height: 70)),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
