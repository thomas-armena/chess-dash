import 'package:flutter/material.dart';
import 'package:chess_dash/grid.dart';
import 'package:chess_dash/gen_board.dart';

class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  List<List<String>> gridData = genBoard(6, 4, 6);

  void handlePress(){
    print("called");
    setState((){
      print("Going to generate board");
      gridData =genBoard(6, 4, 6);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Grid(
        gridData:gridData,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handlePress,
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}