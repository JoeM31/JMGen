/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Button Class
A class which implements Buttons for the GUI.
*/

class Button {
  PVector location;
  float sizeX;
  float sizeY;
  color butColour;
  String buttonText = "";
  boolean overButton = false;
  boolean selected = false;
  boolean plus = false;
  boolean minus = false;
  boolean hasText = false;
  boolean play = false;
  boolean mainPlay = false;
  boolean copy = false;
  boolean stop = false;

  Button(float x, float y, float sx, float sy, color colour) {
    location = new PVector(x, y);
    sizeX = sx;
    sizeY = sy;
    butColour = colour;
  }

  void display() {
    fill(butColour);
    if (plus || minus) {
      fill(200);
      stroke(0);
      strokeWeight(2);
    }
    rect(location.x, location.y, sizeX, sizeY);
    if (plus) {

      stroke(50);
      strokeWeight(2);
      line(location.x+10, location.y+(sizeY/2), location.x+sizeX-10, location.y+(sizeY/2));
      line(location.x+(sizeX/2), location.y+10, location.x+(sizeX/2), location.y+sizeY-10);
    }

    if (minus) {

      stroke(50);
      strokeWeight(2);
      line(location.x+10, location.y+(sizeY/2), location.x+sizeX-10, location.y+(sizeY/2));
    }

    if (play) {
      fill(0);
      triangle(location.x+10, location.y+10, location.x+10, location.y+sizeY-10, location.x+sizeX-10, location.y+(sizeY/2));
    }

    if (stop) {
      fill(0);
      rect(location.x+10, location.y+10, sizeX-20, sizeY-20);
    }

    if (copy) {
      rect(location.x+5, location.y+5, 30, 30);
      rect(location.x+15, location.y+15, 30, 30);
    }

    if (mainPlay) {
      fill(0);
      triangle(location.x+15, location.y+10, location.x+15, location.y+sizeY-10, location.x+sizeX-15, location.y+(sizeY/2));
      strokeWeight(3);
      line(location.x+10, location.y+10, location.x+10, location.y+sizeY-10);
    }

    if (hasText) {
      fill(250);
      textSize(25);
      textAlign(LEFT, TOP);
      text(buttonText, location.x+((sizeX-textWidth(buttonText))/2), location.y+((sizeY-(textAscent()+textDescent()))/2));
    }
  }

  void setPlus() {
    plus = true;
  }
  void setMinus() {
    minus = true;
  }

  color getColour() {
    return (int)butColour;
  }

  void setEnd() {
  }
  void setLeft() {
  }
  void setRight() {
  }
  void setGrey() {
  }
  void setNormal() {
  }

  void update() {
    if (pmouseX > location.x && pmouseX < location.x+sizeX && 
      pmouseY > location.y && pmouseY < location.y+sizeY) {
      overButton = true;
    } 
    else {
      overButton = false;
    }
  }

  void selected() {
    selected = true;
  }
  void notSelected() {
    selected = false;
  }

  void copyButton() {
    copy = true;
  }

  void setPlay() {
    play = true;
  }
  void setStop() {
    stop = true;
  }
  void setMainPlay() {
    mainPlay = true;
  }
  boolean getSelected() {
    return selected;
  }

  void setText(String newString) {
    hasText = true;
    buttonText = newString;
  }

  boolean overButton() {
    return overButton;
  }
}

