import 'package:flutter/material.dart';

import '../utils.dart';

class GradientTouchableContainer extends StatelessWidget {
  /// The border radius of the button.
  final double radius;

  /// The Widget to be contained inside the button.
  final Widget child;

  /// Height of the button.
  final double height;

  /// Width of the button.
  final double width;

  /// Function to be called when the button is pressed.
  final VoidCallback onTap;

  final BoxShadow shadow;

  final bool isExpanded;

  final bool enabled;

  GradientTouchableContainer({
    this.radius = 4,
    @required this.child,
    this.height,
    this.width,
    this.onTap,
    this.shadow,
    this.isExpanded = false,
    this.enabled = true,
  });

  Widget build(BuildContext context) {
    final resultChild = Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: child,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: width,
          height: isExpanded ? null : height,
          padding: EdgeInsets.all(5),
          child: isExpanded
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: resultChild,
                    )
                  ],
                )
              : resultChild,
          decoration: BoxDecoration(
            color: enabled ? null : Colors.grey,
            boxShadow: shadow == null ? null : [shadow],
            borderRadius: BorderRadius.circular(radius),
            gradient: enabled ? kBlueGradient : null,
          ),
        ),
      ),
    );
  }
}
