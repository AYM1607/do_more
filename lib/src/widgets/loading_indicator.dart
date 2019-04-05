import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

/// Loading indicator.
///
/// Shows an animation of the logo.
class LoadingIndicator extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: FlareActor(
        'assets/animations/loading_animation_looped.flr',
        animation: 'Flip',
        fit: BoxFit.contain,
      ),
    );
  }
}
