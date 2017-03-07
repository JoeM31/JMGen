/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Parallel Class
A class which implements the parrallelogram shape for the GUI.
*/

class Parallel extends Shape {
  PShape s;  

  Parallel(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Parallel";

    s = createShape(POINTS);
    s.beginShape();

    s.vertex(0, 0);
    s.vertex((radius*0.8), 0);
    s.vertex(radius, -(radius*0.78));
    s.vertex(20, -(radius*0.78));
    s.vertex(0, 0);


    s.endShape();
    s.disableStyle();
    //s.rotate(PI/2);
  }

  void display() {
    fill(col);
    shape(s, location.x, location.y);
  }


  void update() {
    if (pmouseX > location.x && pmouseX < location.x+r && 
      pmouseY > location.y - r && pmouseY < location.y) {
      overShape = true;
    } 
    else {
      overShape = false;
    }
  }

  String getShape() {
    return "Parallel";
  }

  String messName() {
    String name = "Parallel" + shapeNumber;
    return name;
  }
}

