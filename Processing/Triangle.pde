/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Triangle Class
A class which implements the triangle shape for the GUI.
*/

class Triangle extends Shape {


  Triangle(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Triangle";
  }

  void display() {
    fill(col);
    triangle(location.x, location.y, (location.x+(r/2)), (location.y-r), (location.x+r), location.y);
  }

  void update() {
    if (pmouseX > location.x && pmouseX < location.x+r && 
      pmouseY > location.y-r && pmouseY < location.y) {
      overShape = true;
    } 
    else {
      overShape = false;
    }
  }

  String getShape() {
    return "Triangle";
  }

  String messName() {
    String name = "Triangle" + shapeNumber;
    return name;
  }

}

