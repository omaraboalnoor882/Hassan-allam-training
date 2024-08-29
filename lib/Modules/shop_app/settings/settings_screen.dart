import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'settings Screen',
      style: Theme.of(context).textTheme.bodyLarge)
    );
  }
}
