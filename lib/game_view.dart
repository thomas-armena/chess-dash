import 'package:flutter/material.dart';
import 'package:chess_dash/grid.dart';
import 'package:chess_dash/board.dart';
import 'package:chess_dash/gen_board.dart';

class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  Board board = genBoard(6, 4, 6);

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this
    );

    animation =Tween(begin: 0.0, end: 50.0).animate(animationController);
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  void handlePress(){
    setState((){
      print("Going to generate board");
      board = genBoard(6, 4, 6);
    });
  }

  void onPressPiece(int x, int y){
    setState((){
      animationController.reset();
      animationController.forward();
      board.selectPiece(x, y);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children:<Widget>[

          Expanded(flex: 1, child:Text("TEST")),

          Expanded(
            flex: 5,
            child: Card(
              margin:EdgeInsets.all(20),
              child: Padding(
                padding:EdgeInsets.all(20),
                child:Grid(
                  board:board,
                  onPressPiece: this.onPressPiece,
                  animation: animation,
                ),
              ),
            ),
          ),

          Expanded(flex: 1, child:Text("TEST")),
        ],
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