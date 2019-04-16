import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/avatar.dart';
import '../widgets/gradient_touchable_container.dart';

class PopulatedDrawer extends StatelessWidget {
  /// The user's display name.
  final String userDisplayName;

  /// The url for the user's avatar.
  final String userAvatarUrl;

  /// The current user's email.
  final String userEmail;

  /// The selected screen.
  final Screen selectedScreen;

  PopulatedDrawer({
    this.userDisplayName = '',
    this.userAvatarUrl,
    this.userEmail = '',
    @required this.selectedScreen,
  })  : assert(selectedScreen != null),
        assert(userDisplayName != null),
        assert(userEmail != null);

  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              elevation: 10,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                accountEmail: Text(userEmail),
                accountName: Text(userDisplayName),
                currentAccountPicture: Avatar(
                  imageUrl: userAvatarUrl,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildDrawerTile(
              text: 'Home',
              isSelected: selectedScreen == Screen.home,
              action: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('home/', (_) => false),
            ),
            buildDrawerTile(
              text: 'Events',
              isSelected: selectedScreen == Screen.events,
              action: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('events/', (_) => false),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GradientTouchableContainer(
                onTap: () => onLogoutTap(context),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerTile({
    String text,
    bool isSelected = false,
    VoidCallback action,
  }) {
    final result = Container(
      color: isSelected ? Colors.white10 : null,
      height: 50,
      padding: EdgeInsets.only(
        left: 10,
      ),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
    if (isSelected) {
      return result;
    }
    return GestureDetector(
      onTap: action,
      child: result,
    );
  }

  void onLogoutTap(BuildContext context) {
    authService.signOut();
    // Push the login screen and remove all other screens from the navigator.
    Navigator.of(context).pushNamedAndRemoveUntil('login/', (_) => false);
  }
}

enum Screen {
  home,
  events,
}
