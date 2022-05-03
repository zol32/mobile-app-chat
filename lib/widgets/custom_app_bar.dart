import 'dart:developer';

import 'package:chat_app/constants/menu_action.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final AuthService _auth = AuthService();

  CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Image.asset(
              'assets/logo.png',
              height: 50,
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'CHIT CHAT',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(profileRoute);
          },
        ),
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await _auth.logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
          ],
        );
      }).then((value) => value ?? false);
}
