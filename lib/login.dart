import 'package:flutter/material.dart';
import 'package:vacy/home.dart';
import 'package:vacy/inherit.dart';
import 'package:vacy/web.dart';
import 'dart:io';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
            onPressed: () async {
              await CalendarClientInherited.of(context).calendarClient.singIn();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebView(
                    child: Home(),
                  ),
                ),
              );
            },
            child: Text('Login')),
      ),
    );
  }
}
