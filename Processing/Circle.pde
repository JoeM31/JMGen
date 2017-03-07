/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Circle Class
A class which implements the circle shape for the GUI.
*/

class Circle extends Shape {



  Circle(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Circle";
  }

  void display() {
    fill(col);
    ellipse(location.x, location.y, r, r);
  }


  void update() {
    if (pmouseX > location.x-(r/2) && pmouseX < location.x+(r/2) && 
      pmouseY > location.y-(r/2) && pmouseY < location.y+(r/2)) {
      overShape = true;
    } 
    else {
      overShape = false;
    }
  }

  String getShape() {
    return "Circle";
  }

  String messName() {
    String name = "Circle" + shapeNumber;
    return name;
  }
}

