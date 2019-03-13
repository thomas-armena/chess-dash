import 'package:flutter/material.dart';
import 'package:chess_dash/grid.dart';
import 'package:chess_dash/board.dart';
import 'package:chess_dash/gen_board.dart';

class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  Board board = genBoard(10, 4, 6);

  void handlePress(){
    setState((){
      print("Going to generate board");
      board = genBoard(10, 4, 6);
    });
  }

  void onPressPiece(int x, int y){
    setState((){
      board.selectPiece(x, y);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Grid(
        board:board,
        onPressPiece: this.onPressPiece,
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