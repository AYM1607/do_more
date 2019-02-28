import 'package:flutter/material.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: Text('Tasks'),
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
