/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Square Class
A class which implements the square shape for the GUI.
*/

class Square extends Shape {



  Square(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Square";
  }

  void update() {
    if (pmouseX > location.x && pmouseX < location.x+r && 
      pmouseY > location.y && pmouseY < location.y+r) {
      overShape = true;
    } 
    else {
      overShape = false;
    }
  }

  void display() {
    fill(col);
    rect(location.x, location.y, r, r);
  }

  String messName() {
    String name = "Square" + shapeNumber;
    return name;
  }

  String getShape() {
    return "Square";
  }
}

