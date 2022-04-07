import 'package:flutter/material.dart';

import '../../../exports/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: Values.height50,
                      width: Values.height50,
                      child: child,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
