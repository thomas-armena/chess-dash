import 'package:flutter/material.dart';
import 'package:chess_dash/board.dart';

class Grid extends StatelessWidget {
  Grid({
    this.board,
    this.onPressPiece,
  });

  final Board board; 
  final Function onPressPiece;

  Widget grid(){
    List<Widget> rows = [];
    for(int j = 0; j < board.pieces.length; j++){
      rows.add(this.row(j));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows
    );
  }

  Widget row(int j){
    List<Widget> squares = [];
    for(int i = 0; i < board.pieces[0].length; i++){
      squares.add(this.square(i,j));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: squares
    );
  }

  handlePressFunc(x,y){
    return (){
      onPressPiece(x,y);
    };
  }

  Widget square(int x, int y){
    String name = this.board.pieces[y][x];
    Widget piece;
    Color color;

    if (name == "" || name == "x"){
      piece = null;
    } else {
      piece = Image.asset('assets/png/'+name+'.png');
    }

    if(this.board.selections[y][x] >= this.board.selectCount && this.board.selectCount > 0){
      color = Colors.blue;
    } else if(this.board.selections[y][x] > 0){
      color = Colors.amber;
    } else if (this.board.availablePositions[y][x]){
      color = Colors.green;
    } else {
      color = Colors.white;
    }

    return SizedBox(
      width:70,
      height:70,
      child: GestureDetector(
        onTap: handlePressFunc(x, y),
        child:Card(
          color: color,
          child: Padding(
            padding:EdgeInsets.all(8),
            child: piece,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    return this.grid();
  }
}