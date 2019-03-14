import 'package:chess_dash/coordinate.dart';
import 'package:chess_dash/board.dart';

List<Coordinate> getAvailablePositions(Coordinate currentPosition, String piece, Board board, bool isFreeSpace){
  List<Coordinate> availablePositions = [];
  bool repeat;
  List<Coordinate> moves;
  switch(piece){
    case "bishop":
      moves = [
        Coordinate(-1,-1),
        Coordinate(-1,1),
        Coordinate(1,-1),
        Coordinate(1,1),
      ];
      repeat = true;
      break;
    case "king":
      moves = [
        Coordinate(0,-1),
        Coordinate(1,-1),
        Coordinate(1,0),
        Coordinate(1,1),
        Coordinate(0,1),
        Coordinate(-1,1),
        Coordinate(-1,0),
        Coordinate(-1,-1),
      ];
      repeat = false;
      break;
    case "knight":
      moves = [
        Coordinate(-2,-1),
        Coordinate(2,-1),
        Coordinate(2,1),
        Coordinate(-2,1),
        Coordinate(-1,-2),
        Coordinate(-1,2),
        Coordinate(1,-2),
        Coordinate(1,2),
      ];
      repeat = false;
      break;
    case "pawn":
      moves = [Coordinate(1,-1),Coordinate(-1,-1)];
      repeat = false;
      break;
    case "queen":
      moves = [
        Coordinate(0,-1),
        Coordinate(1,-1),
        Coordinate(1,0),
        Coordinate(1,1),
        Coordinate(0,1),
        Coordinate(-1,1),
        Coordinate(-1,0),
        Coordinate(-1,-1),
      ];
      repeat = true;
      break;
    case "rook":
      moves = [
        Coordinate(0,-1),
        Coordinate(1,0),
        Coordinate(0,1),
        Coordinate(-1,0),
      ];
      repeat = true;
      break;
  }
  for(int i = 0; i < moves.length; i++){
    if(isFreeSpace){
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, moves[i],repeat, board));
    } else {
      Coordinate position =getAvailableAttackFromMove(currentPosition, moves[i], repeat, board);
      if(position != null){
        availablePositions.add(position);
      }
    }
  }
  return availablePositions;
}


List<Coordinate> getAvailablePositionsFromMove(Coordinate currentPosition, Coordinate offset, bool repeat, Board board){
  Coordinate newPosition = addCoordinates(currentPosition, offset);
  String valueOfNewPosition = board.getFromCoordinate(newPosition);

  if(valueOfNewPosition == "" || valueOfNewPosition == "x"){
    if (!repeat) {
      if(valueOfNewPosition == "x") return [];
      return [newPosition];
    }
    var newList =  getAvailablePositionsFromMove(newPosition, offset, repeat, board);
    if(valueOfNewPosition == ""){
      newList.add(newPosition);
    }
    return newList;
  } else {
    return [];
  }
}

Coordinate getAvailableAttackFromMove(Coordinate currentPosition, Coordinate offset, bool repeat, Board board){
  Coordinate newPosition =addCoordinates(currentPosition, offset);
  String valueOfNewPosition = board.getFromCoordinate(newPosition);
  bool insideBoundaries = (
    newPosition.x >= 0 && newPosition.x < board.pieces[0].length &&
    newPosition.y >= 0 && newPosition.y < board.pieces.length
  );

  if(insideBoundaries){
    if(valueOfNewPosition != "" && valueOfNewPosition != "x"){
      return newPosition;
    } else if(repeat){
      return getAvailableAttackFromMove(newPosition, offset, repeat, board);
    } else {
      return null;
    }
  } else {
    return null;
  }
}

List<Coordinate> addList(List<Coordinate> a, List<Coordinate> b){
  for(int i = 0; i < b.length; i++){
    a.add(b[i]);
  }
  return a;
}