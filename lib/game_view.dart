import 'package:flutter/material.dart';
import 'package:chess_dash/grid.dart';
import 'package:chess_dash/board.dart';
import 'package:chess_dash/gen_board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';


class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  Animation timer;
  AnimationController timerController;

  int score;
  int numberOfPieces;
  int xSize;
  int ySize;
  Board prevBoard;
  Board board; 
  GlobalKey paintKey1;
  GlobalKey paintKey2; 

  @override
  void initState(){
    super.initState();
    score = 0;
    numberOfPieces = 3;
    xSize = 4;
    ySize = 6;
    prevBoard = null;
    board =genBoard(numberOfPieces, xSize, ySize);

    this._initiateAnimationForBoardTransitions();
    this._initiateTimer();

    paintKey1 =GlobalKey();
    paintKey2 =GlobalKey();
  }

  void _initiateAnimationForBoardTransitions(){
    animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this
    );

    animationController.addListener((){
      this.setState((){});
    });

    animation =Tween(begin: 0.0, end: 1.0).animate(animationController);
  }

  void _initiateTimer(){
    timerController = AnimationController(
      duration: Duration(seconds: 30),
      vsync: this
    );

    timerController.addListener((){
      this.setState((){});
    });

    timerController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        this.gameOver();
      }
    });

    timer = Tween(begin: 0, end: 1.0).animate(timerController);
    timerController.forward();
  }

  @override
  void dispose(){
    animationController.dispose();
    timerController.dispose();
    super.dispose();
  }

  void handleRefreshPress(){
    setState((){
      board.resetSelections();
    });
  }

  void handleSkipPress(){
    this.goToNextBoard();
  }

  void onPressPiece(int x, int y){
    setState((){
      board.selectPiece(x, y);
      if(board.selectCount == numberOfPieces){
        if(score >= 70){
          numberOfPieces = 8;
        } else if (score >= 50){
          numberOfPieces = 7;
        } else if (score >= 40){
          numberOfPieces = 6;
        } else if (score >= 25){
          numberOfPieces = 5;
        } else if (score >= 10){
          numberOfPieces = 4;
        }
        goToNextBoard();
        score += 1;
        timerController.forward(from:timer.value-0.2);
      }
    });
  }

  void stub(int x, int y){
    return;
  }

  void goToNextBoard(){
    setState((){
      animationController.reset();
      animationController.forward();
      prevBoard = board;
      board =genBoard(numberOfPieces, xSize, ySize);
    });
  }

  Widget _buildBoard(){

    double width = MediaQuery.of(context).size.width;

    List<Widget> boards = [];
    boards.add(
      Grid(
        completed: false,
        skipped: false,
        onPressPiece: this.onPressPiece,
        board: this.board,
        animation: this.animation,
        paintKey: this.paintKey1,
      )
    );
    if (prevBoard != null){
      boards.add(
        Opacity(
          opacity: 1.0 - animation.value,
          child: Transform.translate(
            offset: Offset(animation.value*width, 0.0),
            child: Grid(
              completed: false,
              skipped: false,
              onPressPiece: this.stub,
              board: this.prevBoard,
              animation: this.animation,
            paintKey: this.paintKey2,
            )
          )
        )
      );
    }
    return Stack(children: boards);
  }

  Future<void> gameOver() async {
    this._saveScore(); 
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){},
          child: AlertDialog(
            title: Text('Game Over'),
            content: Text('You scored '+score.toString()+' points!'),
            actions: <Widget>[
              FlatButton(
                child: Text('menu'),
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _saveScore() async {
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    int currentMaxScore = (prefs.getInt('maxScore') ?? 0);
    int newMaxScore = max(score, currentMaxScore);
    await prefs.setInt('maxScore', newMaxScore);
  }

  Widget _buildStatusSection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(this.score.toString()),
        LinearProgressIndicator(
          value:timer.value.toDouble(),
        )
      ]
    );
  }

  Widget _buildButtonSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: 'Refresh board',
          onPressed: handleRefreshPress,
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          tooltip: 'Skip board',
          onPressed: handleSkipPress,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children:<Widget>[
          Expanded(
            flex: 1,
            child: this._buildStatusSection()
          ),
          Expanded(
            flex: 4,
            child: this._buildBoard(),
          ),
          Expanded(
            flex: 1,
            child: this._buildButtonSection(),
          ),
        ],
      ),
    );
  }
}