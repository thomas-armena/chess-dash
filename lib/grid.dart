import 'package:flutter/material.dart';
import 'package:chess_dash/board.dart';

class Grid extends AnimatedWidget {
  Grid({
    this.board,
    this.onPressPiece,
    this.completed,
    this.skipped,
    this.paintKey,
    Key key,
    Animation animation
  }): super(key: key, listenable: animation);


  final GlobalKey paintKey;
  final Board board; 
  final Function onPressPiece;
  final bool completed;
  final bool skipped;

  Widget grid(Function cell){
    List<Widget> rows = [];
    for(int j = 0; j < board.pieces.length; j++){
      rows.add(this.row(j, cell));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows
    );
  }

  Widget row(int j, Function cell){
    List<Widget> squares = [];
    for(int i = 0; i < board.pieces[0].length; i++){
      Widget cellWidget = Expanded(child: cell(i,j), flex: 1);
      squares.add(cellWidget);
    }
    return Expanded(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: squares
      ),
      flex: 1,
    );
  }

  Widget piece(int x, int y){
    String name = this.board.pieces[y][x];
    Widget piece;

    if (name == "" || name == "x"){
      piece = null;
    } else {
      piece = Image.asset('assets/png/'+name+'.png');
    }

    return GestureDetector(
      onTap: handlePressFunc(x, y),
      child: Padding(
        child:piece,
        padding: EdgeInsets.all(12),
      ),
    );
  }

  Widget highlight(int x, int y){

    if(this.board == null){
      return null;
    }
    
    String name = this.board.pieces[y][x];
    Color color;
    double marginValue;
    int cellStatus = this.board.selections[y][x];
    if (cellStatus > 0){
      color = Colors.blue;
      marginValue = 6;
    } else if (name == "" || name == "x"){
      color = Colors.grey[200];
      marginValue = 20;
    } else if (this.board.availablePositions[y][x]){
      color = Colors.green[200];
      marginValue = 12;
    } else {
      color = Colors.white;
      marginValue = 25;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin:EdgeInsets.all(marginValue),
      key: this.board.globalKeys[y][x],
      child: Container(
        decoration: BoxDecoration(
          shape:BoxShape.circle,
          color: color,
        ),
      )
    );

  }

  handlePressFunc(x,y){
    return (){
      onPressPiece(x,y);
    };
  }

  @override
  Widget build(BuildContext context){

    Color gridContainerColor;
    if (this.completed){
      gridContainerColor = Colors.green;
    } else if (this.skipped){
      gridContainerColor = Colors.red;
    } else {
      gridContainerColor = Colors.white;
    }

    return AspectRatio(
        aspectRatio: board.pieces[0].length / board.pieces.length,
        child:AnimatedContainer(
        duration:Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: gridContainerColor,
          borderRadius:BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              spreadRadius: 2,
              blurRadius: 5,
              offset:Offset(2, 2)
            )
          ]
        ),
        margin:EdgeInsets.all(20),
        child: Padding(
          padding:EdgeInsets.all(20),
          child:Stack(
            children:<Widget>[
              this.grid(this.highlight),
              CustomPaint(
                key:this.paintKey,
                painter: LinePainter(
                  board: this.board,
                  paintKey: this.paintKey,
                ),
                child:this.grid(this.piece)
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  LinePainter({this.board, this.paintKey});
  final Board board;
  final GlobalKey paintKey;

  @override
  void paint(Canvas canvas, Size size){
    int xSize = this.board.pieces[0].length;
    int ySize = this.board.pieces.length;

    RenderBox paintRenderBox =paintKey.currentContext.findRenderObject();
    Offset paintPosition =paintRenderBox.localToGlobal(Offset.zero);

    List<List<Offset>> positions = List<List<Offset>>.generate(
      ySize,
      (i) => List<Offset>.generate(
        xSize,
        (j) => Offset(0,0),
      )
    );

    if(this.board.globalKeys[0][0].currentContext != null){
      for(int y = 0; y < ySize; y++){
        for(int x = 0; x < xSize; x++){
          RenderBox renderBox = this.board.globalKeys[y][x].currentContext.findRenderObject();
          Offset position =renderBox.localToGlobal(Offset.zero);
          double width =renderBox.size.width;
          double height = renderBox.size.height;
          Offset centeredPosition = Offset(position.dx + width/2, position.dy +height/2);
          Offset realPosition = Offset(centeredPosition.dx - paintPosition.dx, centeredPosition.dy - paintPosition.dy);
          positions[y][x] = realPosition;
        }
      }
    }

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8.0;
    // center of the canvas is (x,y) => (width/2, height/2)
    for(int i = 1; i < this.board.path.length; i++){
      int xPrevIndex = this.board.path[i-1].x;
      int yPrevIndex = this.board.path[i-1].y;
      int xCurrIndex = this.board.path[i].x;
      int yCurrIndex = this.board.path[i].y;

      canvas.drawLine(positions[yPrevIndex][xPrevIndex], positions[yCurrIndex][xCurrIndex],paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}
