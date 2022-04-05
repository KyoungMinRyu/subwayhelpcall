import 'package:flutter/material.dart';
import 'package:subwayhelpcall/Loading/loading_page.dart';
import 'package:subwayhelpcall/Login/login_page.dart';
import 'package:subwayhelpcall/Pages/office_add.dart';
import 'package:subwayhelpcall/Pages/office_delete.dart';
import 'package:subwayhelpcall/Pages/office_page.dart';
import 'package:subwayhelpcall/Pages/office_update.dart';
import 'package:subwayhelpcall/Pages/office_update_edit.dart';
import 'package:subwayhelpcall/Pages/subway_page.dart';
import 'package:subwayhelpcall/Pages/subway_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // home: SubwayView()
      home: LoadingPage(),
    );
  }
}
