import 'package:flutter/material.dart';

import '../blocs/new_task_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/big_text_input.dart';
import '../widgets/gradient_touchable_container.dart';
import '../widgets/priority_selector.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  static const kLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const kButtonStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

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
              onChanged: bloc.setText,
            ),
            SizedBox(
              height: 15,
            ),
            buildDropdownSection(),
            SizedBox(
              height: 15,
            ),
            buildPrioritySelectorSection(bloc),
            SizedBox(
              height: 20,
            ),
            GradientTouchableContainer(
              height: 40,
              width: 330,
              radius: 8,
              child: Text(
                'Submit',
                style: kButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownSection() {
    return Row(
      children: <Widget>[
        Text(
          'Event',
          style: kLabelStyle,
        ),
        Spacer(),
        CustomDropdownButton(
          width: 230,
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
    );
  }

  Widget buildPrioritySelectorSection(NewTaskBloc bloc) {
    return Row(
      children: <Widget>[
        Text(
          'Priority',
          style: kLabelStyle,
        ),
        Spacer(),
        PrioritySelector(
          onChage: bloc.setPriority,
          width: 230,
        ),
      ],
    );
  }
}
