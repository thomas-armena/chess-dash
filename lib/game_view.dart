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

  int numberOfPieces;
  int xSize;
  int ySize;
  Board board; 
  Board nextBoard;

  @override
  void initState(){
    super.initState();
    numberOfPieces = 6;
    xSize = 4;
    ySize = 6;
    board =genBoard(numberOfPieces, xSize, ySize);
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
      board.resetSelections();
    });
  }

  void onPressPiece(int x, int y){
    setState((){
      animationController.reset();
      animationController.forward();
      board.selectPiece(x, y);
      if(board.selectCount ==numberOfPieces){
        board =genBoard(numberOfPieces, xSize, ySize);
      }
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
            child: Grid(
              onPressPiece: this.onPressPiece,
              board: this.board,
              animation: this.animation,
            )
          ),

          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh board',
              onPressed: handlePress,
            )
          )
        ],
      ),
    );
  }
}