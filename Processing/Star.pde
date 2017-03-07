/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Star Class
A class which implements the star shape for the GUI.
*/

class Star extends Shape {

  PShape s;

  Star(float x, float y, float radius, int index, color colour) {
    super(x, y, radius, index, colour);
    shapeType = "Star";


    s = createShape();
    s.beginShape();
    float angle = TWO_PI / 5;
    float halfAngle = angle/2.0;

    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = cos(a) * (radius/4);
      float sy = sin(a) * (radius/4);
      s.vertex(sx, sy);
      sx = cos(a+halfAngle) * (radius/2);
      sy = sin(a+halfAngle) * (radius/2);
      s.vertex(sx, sy);
    }
    s.endShape(CLOSE);
    s.disableStyle();
    s.isVisible();
    s.rotate(0.3);
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

  void display() {
    fill(col);
    shape(s, location.x, location.y);
  }

  String getShape() {
    return "Star";
  }

  String messName() {
    String name = "Star" + shapeNumber;
    return name;
  }
}

