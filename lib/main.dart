import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vacy/home.dart';
import 'package:vacy/inherit.dart';
import 'package:vacy/login.dart';
import 'package:vacy/web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarClientInherited(
      child: MaterialApp(
        darkTheme: ThemeData.light().copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                headline6: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 21, fontWeight: FontWeight.w400),
                caption: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 15, fontWeight: FontWeight.normal))),
        debugShowCheckedModeBanner: false,
        title: 'Vacy Vacy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WebView(child: Login()),
      ),
    );
  }
}
