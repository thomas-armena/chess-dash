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

  //Start at a random spot
  int yPos = random.nextInt(ySize);
  int xPos = random.nextInt(xSize);
  int yPosPrev;
  int xPosPrev;
  if (yPos == 0){
    piece = _chooseRandomPiece(true);
  } else {
    piece =_chooseRandomPiece(false);
  }
  grid[yPos][xPos] = piece;
  print(xPos.toString() + " " + yPos.toString() + " " + piece); 

  for(int i = 1; i < numberOfPieces; i++){

    //Move to random available spot
    var availablePositions = getAvaliablePositions(xPos, yPos, grid, piece);
    int randomIndex = random.nextInt(availablePositions.length);
    yPosPrev = yPos;
    xPosPrev = xPos;
    yPos = availablePositions[randomIndex][1];
    xPos = availablePositions[randomIndex][0];

    //choose a random piece
    if (yPos == 0){
      piece = _chooseRandomPiece(true);
    } else {
      piece =_chooseRandomPiece(false);
    }

    //Mark new piece in new spot
    grid[yPos][xPos] = piece;

    //Mark the path of the movement
    var pathPositions = getPathPositions(xPosPrev, yPosPrev, xPos, yPos);
    for(int j = 0; j < pathPositions.length; j++){
      int yPathPos = pathPositions[j][1];
      int xPathPos = pathPositions[j][0];
      print('---->'+xPathPos.toString() + ' ' + yPathPos.toString());
      if(grid[yPathPos][xPathPos] == ""){
        grid[yPathPos][xPathPos] = 'x';
      }
    }
    print(xPos.toString() + " " + yPos.toString() + " " + piece); 

  }
  print(grid.toString());
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

List<List<int>> getPathPositions(x1, y1, x2, y2){
  List<List<int>> pathPositions = [];
  
  bool isRightwards = x2 > x1;
  bool isDownwards = y2 > y1;
  int sign; 

  if (isRightwards) sign = 1;
  else sign = -1;
  List<int> xPathPositions = [];
  for(int x = x1; x2 != x; x += sign){
    xPathPositions.add(x);
  }

  if (isDownwards) sign = 1;
  else sign = -1;
  List<int> yPathPositions = [];
  for(int y = y1; y2 != y; y += sign){
    yPathPositions.add(y);
  }
  //print(xPathPositions.toString());
  //print(yPathPositions.toString());

  if(y2 == y1){
    for(int i = 1; i < xPathPositions.length; i++){
      pathPositions.add([xPathPositions[i], y1]);
    }
  } else if(x2 == x1){
    for(int i = 1; i < yPathPositions.length; i++){
      pathPositions.add([x1, yPathPositions[i]]);
    }
  } else if((x2 - x1).abs() == (y2 - y1).abs()){

    for(int i = 1; i < yPathPositions.length; i++){
      pathPositions.add([xPathPositions[i], yPathPositions[i]]);
    }
  }
  return pathPositions;
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


