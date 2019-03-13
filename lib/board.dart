import 'package:chess_dash/coordinate.dart';

class Board {
  List<List<String>> pieces;
  List<List<int>> selections;
  int selectCount;
  
  Board(xSize, ySize){

    selectCount = 0;

    this.pieces = List<List<String>>.generate(
      ySize, 
      (i) => List<String>.generate(
        xSize,
        (j) => "",
      )
    );

    this.selections = List<List<int>>.generate(
      ySize, 
      (i) => List<int>.generate(
        xSize,
        (j) => 0,
      )
    );
  }

  String get(int x, int y){
    return pieces[y][x];
  }

  String getFromCoordinate(Coordinate coordinate){
    if (coordinate.x >= this.pieces[0].length || 
      coordinate.y >= this.pieces.length ||
      coordinate.x < 0 ||
      coordinate.y < 0
    ){
      return null;
    }
    return this.pieces[coordinate.y][coordinate.x];
  }

  void set(int x, int y, String piece){
    this.pieces[y][x] = piece;
  }

  void setFromCoordinate(Coordinate coordinate, String piece){
    this.pieces[coordinate.y][coordinate.x] = piece;
  }

  void selectPiece(int x, int y){
    this.selectCount += 1;
    this.selections[y][x] = this.selectCount;
  }

  void resetSelections(){
    this.selectCount = 0;
    for(int y = 0; y < this.selections.length; y++){
      for(int x = 0; x < this.selections[0].length; x++){
        this.selections[y][x] = 0;
      }
    }
  }

}