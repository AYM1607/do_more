import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

/// Loading indicator.
///
/// Shows an animation of the logo.
class LoadingIndicator extends StatelessWidget {
  final double size;

  LoadingIndicator({
    this.size = 70,
  });

  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: FlareActor(
        'assets/animations/loading_animation_looped.flr',
        animation: 'Flip',
        fit: BoxFit.contain,
      ),
    );
  }
}
