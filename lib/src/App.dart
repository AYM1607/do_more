import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './resources/google_sign_in_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './resources/firebase_storage_provider.dart';

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  File image;
  FirebaseStorageProvider provider = FirebaseStorageProvider();
  StorageUploadTask task;

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: Column(
          children: <Widget>[
            Text('Tasks'),
            MaterialButton(
              child: Text('Upload Picture'),
              onPressed: uploadPicture,
            ),
            buildImage(),
            buildFromTask(),
          ],
        ),
      ),
    );
  }

  Future<void> uploadPicture() async {
    final imageTaken = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image = imageTaken;
    });
    task = provider.uploadFile(imageTaken);
  }

  Widget buildImage() {
    if (image == null) {
      return Text('No image yet');
    }
    return Image.file(image);
  }

  Widget buildFromTask() {
    if (task == null) {
      return Text('No task yet');
    }
    return StreamBuilder(
      stream: task.events,
      builder: (context, AsyncSnapshot<StorageTaskEvent> snapshot) {
        if (!snapshot.hasData) {
          return Text('No task yet');
        } else if (task.isComplete) {
          return Icon(Icons.check);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
