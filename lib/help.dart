import 'package:flutter/material.dart';
import 'package:chess_dash/grid.dart';
import 'package:chess_dash/board.dart';


class Help extends StatefulWidget {

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> with TickerProviderStateMixin {
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
  List<Board> boards;
  List<Widget> helpContents;
  GlobalKey paintKey1;
  GlobalKey paintKey2; 

  @override
  void initState(){
    super.initState();
    score = 0;
    xSize = 4;
    ySize = 6;
    this.boards = [];
    this.helpContents = [];
    this._initiateBoards();
    prevBoard = null;
    board = this.boards[score];
    this._initiateAnimationForBoardTransitions();
    this._initiateTimer();

    new Future.delayed(Duration.zero,(){this._showTip(context, this.helpContents[this.score]);});

    paintKey1 =GlobalKey();
    paintKey2 =GlobalKey();
  }

  void _initiateBoards(){
    Board board1 = Board(xSize, ySize);
    board1.set(1, 2, 'queen');
    board1.set(1, 3, 'queen');
    board1.set(2, 3, 'queen');
    boards.add(board1);
    helpContents.add(Text('To complete a puzzle, you must connect all the chess pieces on the grid by tapping them.'));

    Board board2 = Board(xSize, ySize);
    board2.set(1,3,'rook');
    board2.set(3,3,'pawn');
    board2.set(2,2,'pawn');
    boards.add(board2);
    helpContents.add(Text('Pieces can only be connected with valid chess moves. You can reset the board by pressing the left reset icon'));

    Board board3 = Board(xSize, ySize);
    board3.set(1,1, 'pawn');
    board3.set(1,3, 'pawn');
    board3.set(2,2, 'pawn');
    boards.add(board3);
    helpContents.add(Text('Pawns can move one space diagonally left or right'));

    Board board4 = Board(xSize, ySize);
    board4.set(1,1, 'king');
    board4.set(1,2, 'king');
    board4.set(1,3, 'king');
    board4.set(2,3, 'king');
    board4.set(3,2, 'king');
    board4.set(2,1, 'king');
    boards.add(board4);
    helpContents.add(Text('Kings can move one space in any direction'));

    Board board5 = Board(xSize, ySize);
    board5.set(0,0, 'queen');
    board5.set(0,5, 'queen');
    board5.set(3,5, 'queen');
    board5.set(2,4, 'queen');
    boards.add(board5);
    helpContents.add(Text('Queens can move multiple spaces in any direction'));

    Board board6 = Board(xSize, ySize);
    board6.set(1,1, 'rook');
    board6.set(1,4, 'rook');
    board6.set(3,4, 'rook');
    board6.set(3,2, 'rook');
    boards.add(board6);
    helpContents.add(Text('Rooks can move multiple spaces horizontally or vertically'));

    Board board7 = Board(xSize, ySize);
    board7.set(0,3, 'bishop');
    board7.set(1,4, 'bishop');
    board7.set(3,2, 'bishop');
    board7.set(2,1, 'bishop');
    boards.add(board7);
    helpContents.add(Text('Bishops can move multiple spaces diagonally'));

    Board board8 = Board(xSize, ySize);
    board8.set(1,1, 'knight');
    board8.set(0,3, 'knight');
    board8.set(2,4, 'knight');
    board8.set(3,2, 'knight');
    boards.add(board8);
    helpContents.add(Text('Knights can move in an L pattern.'));

    Board board9 = Board(xSize, ySize);
    board9.set(1,3, 'pawn');
    board9.set(2,2, 'rook');
    board9.set(2,5, 'queen');
    board9.set(0,5, 'king');
    boards.add(board9);
    helpContents.add(Text('You can skip a puzzle by pressing on the right arrow icon beside the restart button'));

    Board board10 = Board(xSize, ySize);
    board10.set(3,1, 'knight');
    board10.set(2,3, 'pawn');
    board10.set(1,2, 'bishop');
    board10.set(2,1, 'pawn');
    boards.add(board10);
    helpContents.add(Text('Watch for the timer! You will get back time by successfully completing puzzles'));
  }
  
  void _showTip(BuildContext context, Widget content){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Padding(
          child:content,
          padding: EdgeInsets.all(20),
        );
      }
    );
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
        _showTip(context, Text('The timer ran out! Normally this means you lose.'));
        timerController.forward(from: 0);
      }
    });

    timer = Tween(begin: 0, end: 1.0).animate(timerController);
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
    if(score == 8){
      score += 1;
      goToNextBoard();
      _showTip(context, this.helpContents[this.score]);
    } else {
      _showTip(context, Text('You cannot skip this tutorial level'));
    }
  }

  void onPressPiece(int x, int y){
    setState((){
      board.selectPiece(x, y);
      if(board.selectCount == this.board.numberOfPieces){
        score += 1;
        if (score < this.boards.length){
          goToNextBoard();
          this._showTip(context, this.helpContents[this.score]);
        } else {
          timerController.stop();
          this.gameOver();
        }
        if (score == 8)
          timerController.forward();
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
      board = this.boards[score];
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){},
          child: AlertDialog(
            title: Text('Complete'), content: Text('Congratulations you completed the tutorial'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.help_outline, size: 40),
        backgroundColor: Colors.black,
        onPressed: (){this._showTip(context, this.helpContents[this.score]);},
      ),
    );
  }
}