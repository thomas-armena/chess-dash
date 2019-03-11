import 'package:chess_dash/coordinate.dart';

class Board {
  List<List<String>> grid;
  
  Board(xSize, ySize){
    this.grid = List<List<String>>.generate(
      ySize, 
      (i) => List<String>.generate(
        xSize,
        (j) => "",
      )
    );
  }

  String get(int x, int y){
    return grid[y][x];
  }

  String getFromCoordinate(Coordinate coordinate){
    if (coordinate.x >= this.grid[0].length || 
      coordinate.y >= this.grid.length ||
      coordinate.x < 0 ||
      coordinate.y < 0
    ){
      return null;
    }
    return this.grid[coordinate.y][coordinate.x];
  }

  void set(int x, int y, String piece){
    this.grid[y][x] = piece;
  }

  void setFromCoordinate(Coordinate coordinate, String piece){
    this.grid[coordinate.y][coordinate.x] = piece;
  }

  

}