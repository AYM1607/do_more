import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';
import '../blocs/new_image_bloc.dart';
import '../models/user_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/fractionally_screen_sized_box.dart';
import '../widgets/gradient_touchable_container.dart';

class NewImageScreen extends StatefulWidget {
  _NewImageScreenState createState() => _NewImageScreenState();
}

class _NewImageScreenState extends State<NewImageScreen> {
  final NewImageBloc bloc = NewImageBloc();
  String dropdownValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
            GradientTouchableContainer(
              height: 40,
              isExpanded: true,
              radius: 8,
              onTap: () {},
              child: Text(
                'Submit',
                style: kSmallTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    final File imgFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    bloc.addPicture(imgFile);
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

              return CustomDropdownButton(
                isExpanded: true,
                value: dropdownValue,
                onChanged: (String value) => onDropdownChanged(bloc, value),
                hint: Text('Event'),
                items: events.map((String event) {
                  return CustomDropdownMenuItem(
                    value: event,
                    child: Text(
                      event,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  void onDropdownChanged(NewImageBloc blco, String value) {
    bloc.setEvent(value);
    setState(() {
      dropdownValue = value;
    });
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
