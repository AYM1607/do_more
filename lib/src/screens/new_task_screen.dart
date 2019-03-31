import 'package:flutter/material.dart';

import '../blocs/new_task_bloc.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final NewTaskBloc bloc = NewTaskBloc();

  Widget build(BuildContext context) {
    return Scaffold();
  }
}
