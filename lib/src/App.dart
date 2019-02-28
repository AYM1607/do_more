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
        body: Text('Tasks'),
      ),
    );
  }
}
