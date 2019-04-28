import 'package:flutter/material.dart';

/// A widget that lets you select the ocurrance of an event.
class OcurranceSelector extends StatefulWidget {
  /// Function to be called when the selected ocurrance changes.
  final Function(List<bool>) onChange;

  OcurranceSelector({@required this.onChange});
  _OcurranceSelectorState createState() => _OcurranceSelectorState();
}

class _OcurranceSelectorState extends State<OcurranceSelector> {
  /// Strings corresponding to every day of the week.
  static const kDayLetters = ['M', 'T', 'W', 'Th', 'F'];

  /// Encoded occurance.
  ///
  /// True means the event occurs in that day.
  List<bool> ocurrance = List<bool>.filled(5, false);

  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < 5; i++) {
      rowChildren.add(
        GestureDetector(
          onTap: () => onDayTap(i),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: ocurrance[i] ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Text(
                kDayLetters[i],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
      if (i != 4) {
        rowChildren.add(
          SizedBox(
            width: 10,
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rowChildren,
    );
  }

  void onDayTap(int index) {
    setState(() {
      ocurrance[index] = !ocurrance[index];
    });
    widget.onChange(ocurrance);
  }
}
