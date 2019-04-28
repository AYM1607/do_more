import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide AppBar;
import 'package:image_picker/image_picker.dart';

import '../utils.dart';
import '../blocs/new_image_bloc.dart';
import '../models/user_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/event_dropdown.dart';
import '../widgets/fractionally_screen_sized_box.dart';
import '../widgets/gradient_touchable_container.dart';

/// A screen that prompts the user for an image and uploads it to
/// firebase storage.
class NewImageScreen extends StatefulWidget {
  /// The name of the event to be preselected in the dropdown menu.
  final String defaultEventName;

  /// Creates a new screen that prompts the user for an image and uploads it to
  /// firevase storage.
  NewImageScreen({
    this.defaultEventName,
  });

  _NewImageScreenState createState() => _NewImageScreenState();
}

class _NewImageScreenState extends State<NewImageScreen> {
  /// An instance of the bloc for this scree.
  NewImageBloc bloc;

  initState() {
    bloc = NewImageBloc(
      defaultEventName: widget.defaultEventName,
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add image',
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () => takePicture(),
                child: Container(
                  height: 300,
                  color: Theme.of(context).cardColor,
                  child: StreamBuilder(
                    stream: bloc.picture,
                    builder: (BuildContext context, AsyncSnapshot<File> snap) {
                      if (!snap.hasData) {
                        return Center(
                          child: Text(
                            'Tap to take picture',
                            style: kSmallTextStyle,
                          ),
                        );
                      }
                      return Image.file(
                        snap.data,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildEventSection(bloc),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: bloc.submitEnabled,
                builder:
                    (BuildContext context, AsyncSnapshot<bool> submitSnap) {
                  return GradientTouchableContainer(
                    height: 40,
                    isExpanded: true,
                    radius: 8,
                    enabled: submitSnap.hasData,
                    onTap: () => onSubmit(),
                    child: Text(
                      'Submit',
                      style: kSmallTextStyle,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget buildEventSection(NewImageBloc bloc) {
    return Row(
      children: <Widget>[
        Text(
          'Event',
          style: kBigTextStyle,
        ),
        Spacer(),
        FractionallyScreenSizedBox(
          widthFactor: 0.7,
          child: StreamBuilder(
            stream: bloc.userModelStream,
            builder: (BuildContext context, AsyncSnapshot<UserModel> snap) {
              List<String> events = [];

              if (snap.hasData) {
                events = snap.data.events;
              }

              return StreamBuilder(
                stream: bloc.eventName,
                builder: (BuildContext context, AsyncSnapshot<String> snap) {
                  return EventDropdown(
                    isExpanded: true,
                    value: snap.data,
                    onChanged: bloc.changeEventName,
                    hint: Text('Event'),
                    items: events.map((String event) {
                      return EventDropdownMenuItem(
                        value: event,
                        child: Text(
                          event,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Saves the image to the storage bucket.
  void onSubmit() async {
    bloc.submit();
    Navigator.of(context).pop();
  }

  // TODO: Add size limit for free users.
  /// Prompts the user to take a picture.
  ///
  /// Updates the file in the bloc.
  Future<void> takePicture() async {
    final File imgFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    bloc.changePicture(imgFile);
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
