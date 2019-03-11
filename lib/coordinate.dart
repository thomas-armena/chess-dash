class Coordinate {
  final int x;
  final int y;
  Coordinate(this.x, this.y);
}

Coordinate addCoordinates(Coordinate a, Coordinate b){
  return Coordinate(a.x + b.x, a.y + b.y);
}