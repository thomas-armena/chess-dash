import 'package:chess_dash/coordinate.dart';
import 'package:chess_dash/available_positions.dart';
import 'package:flutter/widgets.dart';

class Board {
  List<List<String>> pieces;
  List<List<int>> selections;
  List<Coordinate> path;
  List<List<bool>> availablePositions;
  List<List<GlobalKey>> globalKeys;
  int selectCount;
  
  Board(xSize, ySize){

    selectCount = 0;

    this.path = [];

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

    this.availablePositions = List<List<bool>>.generate(
      ySize, 
      (i) => List<bool>.generate(
        xSize,
        (j) => false,
      )
    );

    this.globalKeys = List<List<GlobalKey>>.generate(
      ySize, 
      (i) => List<GlobalKey>.generate(
        xSize,
        (j) => GlobalKey(),
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
    if(this.availablePositions[y][x] || this.selectCount <= 0){
      this.selectCount += 1;
      this.path.add(Coordinate(x,y));
      this.selections[y][x] = this.selectCount;
      this._setAvailablePositions(x, y);
    }
  }

  void resetSelections(){
    this.selectCount = 0;
    this.path = [];
    for(int y = 0; y < this.selections.length; y++){
      for(int x = 0; x < this.selections[0].length; x++){
        this.selections[y][x] = 0;
      }
    }
  }

  void _setAvailablePositions(int x, int y){
    Coordinate currentPosition =Coordinate(x, y);
    List<Coordinate> availablePositions = getAvailablePositions(currentPosition, this.pieces[y][x], this, false);
    print(availablePositions.toString());

    for(int y = 0; y < this.availablePositions.length; y++){
      for(int x = 0; x < this.availablePositions[0].length; x++){
        this.availablePositions[y][x] = false;
      }
    }

    for(int i = 0; i < availablePositions.length; i++){
      print(x);
      print(y);
      this.availablePositions[availablePositions[i].y][availablePositions[i].x] = true;
    }
  }

}