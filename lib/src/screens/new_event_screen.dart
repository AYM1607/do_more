import 'package:flutter/material.dart' hide AppBar;

import '../utils.dart' show kSmallTextStyle;
import '../blocs/new_event_bloc.dart';
import '../widgets/app_bar.dart';
import '../widgets/big_text_input.dart';
import '../widgets/gradient_touchable_container.dart';
import '../widgets/ocurrance_selector.dart';

class NewEventScreen extends StatefulWidget {
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  /// An instance of the bloc corresponding to this screen.
  final bloc = NewEventBloc();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'New Event',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              BigTextInput(
                onChanged: bloc.changeEventName,
                maxCharacters: 16,
                hint: 'My event...',
              ),
              SizedBox(
                height: 15,
              ),
              OcurranceSelector(
                onChange: bloc.changeOcurrance,
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                stream: bloc.submitEnabled,
                builder: (context, submitSnap) {
                  return GradientTouchableContainer(
                    height: 40,
                    radius: 8,
                    isExpanded: true,
                    enabled: submitSnap.hasData,
                    onTap: () => onSubmit(context),
                    child: Text(
                      'Submit',
                      style: kSmallTextStyle,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit(BuildContext context) async {
    await bloc.submit();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
