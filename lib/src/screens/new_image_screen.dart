import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';
import '../blocs/new_image_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/gradient_touchable_container.dart';

class NewImageScreen extends StatefulWidget {
  _NewImageScreenState createState() => _NewImageScreenState();
}

class _NewImageScreenState extends State<NewImageScreen> {
  final NewImageBloc bloc = NewImageBloc();

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
            buildEventSection(),
            SizedBox(
              height: 10,
            ),
            GradientTouchableContainer(
              height: 40,
              width: 350,
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

  Widget buildEventSection() {
    return Row(
      children: <Widget>[
        Text(
          'Event',
          style: kBigTextStyle,
        ),
        Spacer(),
        CustomDropdownButton(
          width: 200,
        ),
      ],
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
