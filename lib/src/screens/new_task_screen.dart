import 'package:flutter/material.dart';

import '../blocs/new_task_bloc.dart';
import '../widgets/custom_app_bar.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final NewTaskBloc bloc = NewTaskBloc();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add task',
      ),
    );
  }
}
