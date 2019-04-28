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

  /// Hint to be shown in the input.
  final String hint;

  /// The maximum amount of character to be allowed on the input.
  final int maxCharacters;

  BigTextInput({
    @required this.onChanged,
    this.height,
    this.width,
    this.elevated = true,
    this.initialValue = '',
    this.hint = '',
    @required this.maxCharacters,
  }) : assert(maxCharacters != null);

  @override
  _BigTextInputState createState() => _BigTextInputState();
}

class _BigTextInputState extends State<BigTextInput> {
  /// Custom controller for the text input.
  TextEditingController _controller;

  /// Flag to indicate if the initial value has been set or not.
  ///
  /// Without this flag the text property of the controller will be set
  /// continuously and the cursor inside the text field will return to the
  /// origin when tapped.
  bool initialValueWasSet = false;

  /// Setus up the controller.
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(controllerListener);
    super.initState();
  }

  // Set the text property of the controller if the newly rendered widget
  // contains a non empty initial value. It should only be done once, otherwise
  // the cursor will continuously return to the start of the input when tapped.
  void didUpdateWidget(oldWidget) {
    if (widget.initialValue != '' && !initialValueWasSet) {
      _controller.text = widget.initialValue;
      initialValueWasSet = true;
    }
    super.didUpdateWidget(oldWidget);
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
            maxLength: widget.maxCharacters,
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
              hintText: widget.hint,
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
