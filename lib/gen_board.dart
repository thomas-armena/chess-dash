import 'dart:math';

List<List<String>> genBoard(int numberOfPieces, int xSize, int ySize) {
  print("Generated a new board.");
  var grid = List<List<String>>.generate(
    ySize, 
    (i) => List<String>.generate(
      xSize,
      (j) => "",
    )
  );

  Random random = new Random();
  String piece;
  int yPos = random.nextInt(ySize);
  int xPos = random.nextInt(xSize);
  if (yPos == 0){
    piece = _chooseRandomPiece(true);
  } else {
    piece =_chooseRandomPiece(false);
  }

  for(int i = 0; i < numberOfPieces; i++){
    print(xPos.toString() + " " + yPos.toString() + " " + piece); 
    grid[yPos][xPos] = piece;
    var availablePositions = getAvaliablePositions(xPos, yPos, grid, piece);
    int randomIndex = random.nextInt(availablePositions.length);
    xPos = availablePositions[randomIndex][0];
    yPos = availablePositions[randomIndex][1];
    if (yPos == 0){
      piece = _chooseRandomPiece(true);
    } else {
      piece =_chooseRandomPiece(false);
    }
  }
  return grid;
}

String _chooseRandomPiece(bool excludePawn){
  Random random = new Random();
  if(excludePawn){
    int randomNum = random.nextInt(5);
    return ["bishop","king","knight","queen","rook"][randomNum];
  } else {
    int randomNum = random.nextInt(6);
    return ["bishop","king","knight","pawn","queen","rook"][randomNum];
  }
}

List<List<int>> getAvaliablePositions(int xCurr, int yCurr, List<List<String>> grid, String piece){
  List<List<int>> availablePositions = [];
  Function positionChecker;
  switch(piece){
    case "bishop":
      positionChecker = isDiagonal;
      break;
    case "king":
      positionChecker = isKing;
      break;
    case "knight":
      positionChecker = isL;
      break;
    case "pawn":
      positionChecker = isPawn;
      break;
    case "queen":
      positionChecker = isQueen;
      break;
    case "rook":
      positionChecker = isStraight;
      break;
  }
  for(int y = 0; y < grid.length; y++){
    for(int x = 0; x < grid[0].length; x++){
      bool inSamePosition = (x == xCurr && y == yCurr);
      bool unOccupied = grid[y][x] == "";
      if(positionChecker(xCurr, yCurr, x, y) && !inSamePosition && unOccupied){
        availablePositions.add([x,y]);
      }
    }
  }
  return availablePositions;
}

bool isDiagonal(int x1, int y1, int x2, int y2) {
  return (x2 - x1).abs() == (y2 - y1).abs();
}

bool isStraight(int x1, int y1, int x2, int y2) {
  return (x1 == x2) || (y1 == y2);
}

bool isL(int x1, int y1, int x2, int y2) {
  bool isHorizontalL = (x2 - x1).abs() == 2 && (y2 - y1).abs() == 1;
  bool isVerticalL = (x2 - x1).abs() == 1 && (y2 - y1).abs() == 2;
  return isHorizontalL || isVerticalL;
}

bool isKing(int x1, int y1, int x2, int y2) {
  return (x2 - x1).abs() <= 1 && (y2 - y1).abs() <= 1;
}

bool isQueen(int x1, int y1, int x2, int y2) {
  return isDiagonal(x1, y1, x2, y2) || isStraight(x1, y1, x2, y2);
}

bool isPawn(int x1, int y1, int x2, int y2) {
  return (y2 - y1) == -1 && (x2 - x1).abs() == 1;
}


