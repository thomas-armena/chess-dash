import 'dart:math';
import 'package:chess_dash/coordinate.dart';
import 'package:chess_dash/board.dart';

Random random = new Random();

Board genBoard(int numberOfPieces, int xSize, int ySize) {
  Board board = Board(xSize, ySize);

  Coordinate previousPosition;
  Coordinate currentPosition = getRandomCoordinate(xSize, ySize);
  String currentPiece = getRandomPiece(currentPosition);
  board.set(currentPosition.x, currentPosition.y, currentPiece);

  print(currentPosition.x.toString() + " " + currentPosition.y.toString() + " " + currentPiece); 

  for(int i = 1; i < numberOfPieces; i++){
    previousPosition = currentPosition;
    currentPosition = getRandomAvailablePosition(currentPosition, currentPiece, board);
    currentPiece = getRandomPiece(currentPosition);
    board.setFromCoordinate(currentPosition, currentPiece);

    //Mark the path of the movement
    var pathPositions = getPathPositions(previousPosition, currentPosition);
    for(int j = 0; j < pathPositions.length; j++){
      var pathPosition =pathPositions[j];
      print('---->'+pathPosition.x.toString() + ' ' + pathPosition.y.toString());
      if(board.getFromCoordinate(pathPosition) == ""){
        board.setFromCoordinate(pathPosition, 'x');
      }
    }
    print(currentPosition.x.toString() + " " + currentPosition.y.toString() + " " + currentPiece); 
  }

  return board;
}

Coordinate getRandomAvailablePosition(Coordinate currentPosition, String currentPiece, Board board){
    var availablePositions = getAvailablePositions(currentPosition, currentPiece, board);
    int randomIndex = random.nextInt(availablePositions.length);
    return availablePositions[randomIndex];

}

String getRandomPiece(Coordinate currentPosition){
    if (currentPosition.y == 0){ //Don't choose pawn if on first row of the grid
      return chooseRandomStringFromList(['bishop','king','knight','queen','rook']);
    } else {
      return chooseRandomStringFromList(['bishop','king','knight','queen','rook','pawn']);
    }
}

String chooseRandomStringFromList(List<String> list){
  int randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}

Coordinate getRandomCoordinate(xSize, ySize){
  return Coordinate(random.nextInt(xSize), random.nextInt(ySize));
}


List<Coordinate> getAvailablePositions(Coordinate currentPosition, String piece, Board board){
  List<Coordinate> availablePositions = [];
  switch(piece){
    case "bishop":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,-1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,1),true, board));
      break;
    case "king":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,0),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0,1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,0),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,-1),false, board));
      break;
    case "knight":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-2,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(2,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(2,1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-2,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,-2),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,2),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-2),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-2),false, board));
      break;
    case "pawn":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-1),false, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,-1),false, board));
      break;
    case "queen":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0,-1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,-1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,0),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1,1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0,1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,0),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,-1),true, board));
      break;
    case "rook":
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0,-1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(1, 0),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(0, 1),true, board));
      addList(availablePositions,getAvailablePositionsFromMove(currentPosition, Coordinate(-1,0),true, board));
  }
  return availablePositions;
}

List<Coordinate> getPathPositions(Coordinate position1, Coordinate position2){
  List<Coordinate> pathPositions = [];
  
  bool isRightwards = position2.x > position1.x;
  bool isDownwards = position2.y > position1.y;
  int sign; 

  if (isRightwards) sign = 1;
  else sign = -1;
  List<int> xPathPositions = [];
  for(int x = position1.x; position2.x != x; x += sign){
    xPathPositions.add(x);
  }

  if (isDownwards) sign = 1;
  else sign = -1;
  List<int> yPathPositions = [];
  for(int y = position1.y; position2.y != y; y += sign){
    yPathPositions.add(y);
  }

  if(position1.y == position2.y){
    for(int i = 1; i < xPathPositions.length; i++){
      pathPositions.add(Coordinate(xPathPositions[i], position1.y));
    }
  } else if(position1.x == position2.x){
    for(int i = 1; i < yPathPositions.length; i++){
      pathPositions.add(Coordinate(position1.x, yPathPositions[i]));
    }
  } else if((position2.x - position1.x).abs() == (position2.y - position1.y).abs()){

    for(int i = 1; i < yPathPositions.length; i++){
      pathPositions.add(Coordinate(xPathPositions[i], yPathPositions[i]));
    }
  }
  return pathPositions;
}

List<Coordinate> getAvailablePositionsFromMove(Coordinate currentPosition, Coordinate offset, bool repeat, Board board){
  Coordinate newPosition = addCoordinates(currentPosition, offset);
  String valueOfNewPosition = board.getFromCoordinate(newPosition);

  if(valueOfNewPosition == "" || valueOfNewPosition == "x"){
    if (!repeat) return [newPosition];
    var newList =  getAvailablePositionsFromMove(newPosition, offset, repeat, board);
    if(valueOfNewPosition == ""){
      newList.add(newPosition);
    }
    return newList;
  } else {
    return [];
  }
}

List<Coordinate> addList(List<Coordinate> a, List<Coordinate> b){
  for(int i = 0; i < b.length; i++){
    a.add(b[i]);
  }
  return a;
}
