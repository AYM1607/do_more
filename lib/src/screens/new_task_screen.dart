import 'package:flutter/material.dart';

import '../blocs/new_task_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/big_text_input.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            BigTextInput(
              height: 95,
            ),
            SizedBox(
              height: 10,
            ),
            CustomDropdownButton(
              hint: Text('Event'),
              onChanged: (item) {},
              items: ['Math', 'Lenguajes', 'Redes'].map((String name) {
                return CustomDropdownMenuItem(
                  value: name,
                  child: Text(
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
