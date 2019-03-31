import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A card with a label and circular button.
///
/// Let's you specify the text shown and the action to perform when the circular
/// button is pressed.
class NewItemDialogButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  NewItemDialogButton({
    @required this.onTap,
    this.label = '',
  }) : assert(onTap != null);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        bottom: 30,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 170,
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          FloatingActionButton(
            child: Icon(FontAwesomeIcons.plus),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
