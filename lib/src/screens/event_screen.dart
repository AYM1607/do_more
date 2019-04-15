import 'dart:async';

import 'package:flutter/material.dart';

import '../utils.dart' show getImageThumbnailPath, showUploadStatusSnackBar;
import '../blocs/event_bloc.dart';
import '../screens/gallery_screen.dart';
import '../models/task_model.dart';
import '../widgets/async_thumbnail.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/gradient_touchable_container.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/task_list_tile.dart';

/// A screen that shows all the items linked to an event.
class EventScreen extends StatefulWidget {
  /// The name of the event this screenn is showing.
  final String eventName;

  /// Creates a screen that shows all the items linked to an event.
  ///
  /// The tasks and images are showed in different page views controlled by a
  /// [TabBar].
  EventScreen({
    @required this.eventName,
  });

  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  /// An instance of the bloc for this screen.
  EventBloc bloc;

  /// The controller for the tabbed naviagtion.
  TabController _tabController;

  /// The context of the scaffold being shown.
  ///
  /// Needed for showing snackbars.
  BuildContext _scaffoldContext;

  initState() {
    super.initState();
    bloc = EventBloc(eventName: widget.eventName);
    bloc.fetchTasks();
    bloc.fetchImagesPaths();
    _tabController = TabController(vsync: this, length: 2);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              buildTasksListView(),
              buildMediaView(),
            ],
          );
        },
      ),
    );
  }

  Widget buildAppBar() {
    return CustomAppBar(
      title: widget.eventName,
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: 'Tasks',
          ),
          Tab(
            text: 'Media',
          ),
        ],
      ),
    );
  }

  /// Builds a list of the undone tasks linked to this service.
  Widget buildTasksListView() {
    return StreamBuilder(
      stream: bloc.eventTasks,
      builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snap) {
        if (!snap.hasData) {
          return Center(
            child: LoadingIndicator(),
          );
        }

        return ListView(
          padding: EdgeInsets.only(top: 15),
          children: snap.data
              .map((task) => Container(
                    child: TaskListTile(
                      task: task,
                      hideEventButton: true,
                      onDone: () => bloc.markTaskAsDone(task),
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
      },
    );
  }

  /// Builds the Page view that contains all the thumnails of the pictures
  /// linked to this event.
  Widget buildMediaView() {
    return StreamBuilder(
      stream: bloc.imagesPaths,
      builder: (BuildContext context, AsyncSnapshot<List<String>> listSnap) {
        // Wait until the images paths have been fetched.
        if (!listSnap.hasData) {
          return Center(
            child: LoadingIndicator(),
          );
        }

        return GridView.builder(
          itemCount: listSnap.data.length + 1,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return buildAddPictureButton();
            }
            // Shift the indices since we added a button that's not contained
            // in the original paths list.
            final imagePath = listSnap.data[index - 1];
            bloc.fetchThumbnail(imagePath);

            return GestureDetector(
              onTap: () => openGallery(imageIndex: index - 1),
              child: AsyncThumbnail(
                cacheStream: bloc.thumbnails,
                cacheId: getImageThumbnailPath(imagePath),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
        );
      },
    );
  }

  // TODO: Change the navigation call whent the new package is ready.
  Widget buildAddPictureButton() {
    return GradientTouchableContainer(
      radius: 8,
      onTap: onAddPicturePressed,
      child: Icon(
        Icons.camera_alt,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  /// Pushes a new screen that shows the pictures in full size.
  void openGallery({int imageIndex}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return GalleryScreen(
            fetchImage: bloc.fetchImage,
            cacheStream: bloc.images,
            pathsStream: bloc.imagesPaths,
            initialScreen: imageIndex,
            thumbnailCaceStream: bloc.thumbnails,
          );
        },
      ),
    );
  }

  // TODO: use a block provider instead of passing callbacks
  Future<void> onAddPicturePressed() async {
    await Navigator.of(context).pushNamed('newImage/${bloc.eventName}');
    if (bloc.snackBarStatus.value == false) {
      showUploadStatusSnackBar(
        _scaffoldContext,
        bloc.uploadStatus,
        bloc.updateSnackBarStatus,
      );
    }
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
