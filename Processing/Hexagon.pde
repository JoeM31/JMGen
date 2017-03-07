/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Hexagon Class
A class which implements the hexagon shape for the GUI.
*/

class Hexagon extends Shape {

  PShape s;  

  Hexagon(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Hexagon";

    s = createShape(POINTS);
    s.beginShape();

    s.vertex(-(radius*0.435), -(radius/4));
    s.vertex(0, -(radius/2));
    s.vertex((radius*0.435), -(radius/4));
    s.vertex((radius*0.435), (radius/4));
    s.vertex(0, (radius/2));
    s.vertex(-(radius*0.435), (radius/4));
    s.vertex(-(radius*0.435), -(radius/4));

    s.endShape();
    s.disableStyle();
    s.rotate(PI/2);
  }

  void display() {
    fill(col);
    shape(s, location.x, location.y);
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
    return "Hexagon";
  }

  String messName() {
    String name = "Hexagon" + shapeNumber;
    return name;
  }
}

