import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//HomeScreen -> Class .  StatelessWidget -> Class
class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){ //'build' is a method name
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
        ),
        title: Text('First App'),
        actions: [
          IconButton(
              onPressed: ()
              {
                print('Notification Clicked');
              },
              icon: Icon(
                Icons.notification_important,
              ),
          ),
          Icon(
            Icons.search,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 20.0, //puts a shadow on the appbar
      ),

    );
  }
}