import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  Grid({
    this.gridData,
  });

  final List<List<String>> gridData; 

  Widget grid(){
    List<Widget> rows = [];
    for(int j = 0; j < gridData.length; j++){
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
    for(int i = 0; i < gridData[0].length; i++){
      squares.add(this.square(gridData[j][i]));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: squares
    );
  }

  Widget square(String name){
    Widget piece;
    if (name == "" || name == "x"){
      piece = null;
    } else {
      piece = Image.asset('assets/png/'+name+'.png');
    }
    return SizedBox(
      width:70,
      height:70,
      child: Card(
        child: Padding(
          padding:EdgeInsets.all(8),
          child: piece,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    return this.grid();
  }
}