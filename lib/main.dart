import 'package:flutter/material.dart';
import 'package:chess_dash/home_page.dart';
import 'package:chess_dash/game_view.dart';
import 'package:chess_dash/help.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Chess Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
        "/GameView": (BuildContext context) => new GameView(),
        "/Help": (BuildContext context) => new Help(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}