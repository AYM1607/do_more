import 'package:flutter/material.dart';

import '../blocs/new_image_bloc.dart';
import '../widgets/custom_app_bar.dart';

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
    );
  }
}
