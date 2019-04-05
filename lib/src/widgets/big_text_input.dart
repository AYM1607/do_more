import 'package:flutter/material.dart';

/// A 3 line text input with progress indicator that matches the mocks.
class BigTextInput extends StatefulWidget {
  /// The height of the input.
  final double height;

  /// The width of the input.
  final double width;

  /// Wether the containing card show elevation or not.
  final bool elevated;

  /// Method to be executed when the text is updated.
  final Function(String) onChanged;

  /// The initial value for the input.
  final String initialValue;

  BigTextInput({
    @required this.onChanged,
    this.height,
    this.width,
    this.elevated = true,
    this.initialValue,
  });

  @override
  _BigTextInputState createState() => _BigTextInputState();
}

class _BigTextInputState extends State<BigTextInput> {
  /// Custom controller for the text input.
  TextEditingController _controller;

  /// Setus up the controller.
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(controllerListener);
    super.initState();
  }

  /// Calls [onChanged] when updates are sent by the controller.
  void controllerListener() {
    widget.onChanged(_controller.text);
  }

  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevated ? 10 : 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 50,
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 3,
            maxLength: 220,
            maxLengthEnforced: true,
            cursorColor: Theme.of(context).cursorColor,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              counterStyle: TextStyle(color: Colors.white),
              hintText: 'Do something...',
              hintStyle: TextStyle(
                color: Theme.of(context).cursorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
