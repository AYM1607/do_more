import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './gradient_touchable_container.dart';

//TODO: Add neccessary properties to be able to inform of changes in text field.

/// A search box that mathces the app mocks.
class SearchBox extends StatefulWidget {
  /// Height of the sarch box.
  final double height;

  /// Function to be called when the text changes.
  final Function(String) onChanged;

  /// Creates a search box.
  ///
  /// the height should be equal or larger than 50.
  SearchBox({
    @required this.height,
    @required this.onChanged,
  }) : assert(height >= 50);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  /// Controller for the [TextFiel].
  final TextEditingController _controller = TextEditingController();

  initState() {
    _controller.addListener(() => widget.onChanged(_controller.text));
    super.initState();
  }

  Widget build(BuildContext context) {
    final List<Widget> containerRowChildren = <Widget>[
      SizedBox(
        width: 10,
      ),
      Icon(
        FontAwesomeIcons.sistrix,
        color: Colors.white,
      ),
      SizedBox(
        width: 8,
      ),
      Expanded(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          cursorColor: Colors.white,
          scrollPadding: EdgeInsets.zero,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    ];

    if (_controller.text != '') {
      containerRowChildren.add(
        IconButton(
          icon: Icon(
            FontAwesomeIcons.timesCircle,
            color: Colors.white,
          ),
          onPressed: onClearButtonPressed,
        ),
      );
    }

    return Row(
      children: <Widget>[
        Spacer(flex: 1),
        Expanded(
          flex: 8,
          child: GradientTouchableContainer(
            radius: widget.height / 2,
            height: widget.height,
            shadow: BoxShadow(
              color: Color(0x20FFFFFF),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            child: Row(
              children: containerRowChildren,
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }

  void onClearButtonPressed() {
    _controller.text = '';
    // The controller does not notify its listeners when the text is set
    // explicitely. We have to do it manually.
    widget.onChanged(_controller.text);
    setState(() {});
  }
}
