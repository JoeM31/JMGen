/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Indicator Class
A class which implements the indicators for the scene position.
*/

class Indicator {
  PVector location;
  boolean current = false;


  Indicator(float yLocation) {
    location = new PVector(0, yLocation);
  }

  void updateLocation(float x) {
    location.x = x;
  }

  void current() {
    current = true;
  }

  void notCurrent() {
    current = false;
  }

  void display() {
    strokeWeight(0);
    fill(100);
    if (current) {
      strokeWeight(1);
      fill(250);
    }
    ellipse(location.x, location.y, 15, 15);
  }
}

