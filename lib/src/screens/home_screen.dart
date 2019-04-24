import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils.dart' show showUploadStatusSnackBar;
import '../models/task_model.dart';
import '../blocs/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/new_item_dialog_route.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/populated_drawer.dart';
import '../widgets/search-box.dart';

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _searchBoxHeight = 50.0;

  /// An instance of the bloc for this screen.
  final HomeBloc bloc = HomeBloc();

  /// The context of the scaffold being shown.
  ///
  /// Needed for showing snackbars.
  BuildContext _scaffoldContext;

  StreamSubscription _snackBarStatusSubscription;

  @override
  initState() {
    super.initState();
    bloc.fetchTasks();
    _snackBarStatusSubscription = bloc.snackBarStatus.listen((bool visible) {
      if (visible) {
        showUploadStatusSnackBar(
          _scaffoldContext,
          bloc.uploadStatus,
          bloc.updateSnackBarStatus,
        );
      } else {
        Scaffold.of(_scaffoldContext).hideCurrentSnackBar();
      }
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> userSnap) {
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
            selectedScreen: Screen.home,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesomeIcons.plus),
            backgroundColor: Color(0xFF707070),
            onPressed: () => Navigator.of(context).push(NewItemDialogRoute()),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: HomeAppBar(
            avatarUrl: userAvatarUrl,
            subtitle: 'Hello $userDisplayName!',
          ),
          body: Builder(
            builder: (BuildContext context) {
              _scaffoldContext = context;
              return StreamBuilder(
                stream: bloc.userTasks,
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModel>> snap) {
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
                        onChanged: bloc.updateSearchBoxText,
                        height: 50.0,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    return ListView(
      padding: EdgeInsets.only(top: _searchBoxHeight + 15),
      children: tasks
          .map((task) => Container(
                child: TaskListTile(
                  task: task,
                  onDone: () => bloc.markTaskAsDone(task),
                  onEventPressed: () {
                    // Include the event name in the route.
                    Navigator.of(context).pushNamed('event/${task.event}');
                  },
                  onEditPressed: () {
                    // Include the id of the task to be edited in the route.
                    Navigator.of(context).pushNamed('editTask/${task.id}');
                  },
                ),
                padding: EdgeInsets.only(bottom: 12),
              ))
          .toList()
            ..add(Container(height: 70)),
    );
  }

  @override
  void dispose() {
    _snackBarStatusSubscription.cancel();
    bloc.dispose();
    super.dispose();
  }
}
