/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Arrow Class
A subclass of Button that makes up the arrow buttons for the GUI.
*/

class Arrow extends Button {
  boolean left = true;
  boolean end = false;
  boolean grey = false;

  Arrow(float x, float y, float sx, float sy, color colour) {
    super(x, y, sx, sy, colour);
  }

  void setLeft() {
    left = true;
  }
  void setRight() {
    left = false;
  }
  void setEnd() {
    end = true;
  }
  void setGrey() {
    grey = true;
  }
  void setNormal() {
    grey = false;
  }

  void display() {

    strokeWeight(0);
    fill(50);
    if (grey) {
      fill(150);
    }
    rect(location.x, location.y, sizeX, sizeY);
    strokeWeight(3);
    stroke(250);
    if (left) {
      line(location.x+10, location.y+(sizeY/2), location.x+sizeX-10, location.y+10);
      line(location.x+10, location.y+(sizeY/2), location.x+sizeX-10, location.y+sizeY-10);
    }
    if (!left) {
      line(location.x+10, location.y+10, location.x+sizeX-10, location.y+(sizeY/2));
      line(location.x+10, location.y+sizeY-10, location.x+sizeX-10, location.y+(sizeY/2));
    }

    if (end && left) {
      line(location.x+10, location.y+sizeY-10, location.x+10, location.y+10);
    }

    if (end && !left) {
      line(location.x+sizeX-10, location.y+sizeY-10, location.x+sizeX-10, location.y+10);
    }
  }
}

