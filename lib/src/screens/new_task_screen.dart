import 'package:flutter/material.dart';

import '../utils.dart';
import '../blocs/new_task_bloc.dart';
import '../models/user_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/big_text_input.dart';
import '../widgets/fractionally_screen_sized_box.dart';
import '../widgets/gradient_touchable_container.dart';
import '../widgets/priority_selector.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final NewTaskBloc bloc = NewTaskBloc();
  String dropdownValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add task',
      ),
      body: StreamBuilder(
        stream: bloc.userModelStream,
        builder: (BuildContext context, AsyncSnapshot<UserModel> snap) {
          List<String> events = [];

          if (snap.hasData) {
            events = snap.data.events;
          }

          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    BigTextInput(
                      height: 95,
                      onChanged: bloc.setText,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    buildDropdownSection(events),
                    SizedBox(
                      height: 15,
                    ),
                    buildPrioritySelectorSection(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    GradientTouchableContainer(
                      height: 40,
                      radius: 8,
                      isExpanded: true,
                      onTap: () => onSubmit(context, bloc),
                      child: Text(
                        'Submit',
                        style: kSmallTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // TODO: Refactor to avoid using the dropdownValue property and instead use
  // a stream from the bloc.
  Widget buildDropdownSection(List<String> events) {
    return Row(
      children: <Widget>[
        Text(
          'Event',
          style: kBigTextStyle,
        ),
        Spacer(),
        FractionallyScreenSizedBox(
          widthFactor: 0.6,
          child: CustomDropdownButton(
            isExpanded: true,
            value: dropdownValue,
            onChanged: (String value) => onDropdownChanged(bloc, value),
            hint: Text('Event'),
            items: events.map((String name) {
              return CustomDropdownMenuItem(
                value: name,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildPrioritySelectorSection(NewTaskBloc bloc) {
    return Row(
      children: <Widget>[
        Text(
          'Priority',
          style: kBigTextStyle,
        ),
        Spacer(),
        FractionallyScreenSizedBox(
          widthFactor: 0.6,
          child: PrioritySelector(
            onChage: bloc.setPriority,
          ),
        ),
      ],
    );
  }

  void onDropdownChanged(NewTaskBloc bloc, String newValue) {
    bloc.setEvent(newValue);
    setState(() {
      dropdownValue = newValue;
    });
  }

  void onSubmit(BuildContext context, NewTaskBloc bloc) async {
    await bloc.submit();
    Navigator.of(context).pop();
  }
}
