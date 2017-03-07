/*
Joe Munday
Candidate Numbber: 24836
Creative Project
Shape Class
A superclass which controls all of the shapes for the GUI.
*/

class Shape {
  float r;
  PVector location;
  boolean overShape = false;
  boolean locked = false;
  float xOffset = 0.0; 
  float yOffset = 0.0; 
  color col;
  int shapeNumber;
  String shapeType;
  String name;
  boolean button;

  Shape(float posx, float posy, float size, int shapeIndex, color colour) {
    location = new PVector(posx, posy);
    r = size;
    col = colour;
    shapeNumber = shapeIndex;
    messName();
  }

  void update() {
  }


  void moveMessage(OscP5 oscP5, NetAddress shapeAddress) {
    String name1 = shapeType + " " + shapeNumber;
    println(name1);
    OscMessage myMessage = new OscMessage(name1);
    myMessage.add((int)location.x);
    myMessage.add((float)location.y);

    oscP5.send(myMessage, shapeAddress);
  }


  void setLocation(float x, float y) {
    location.x = x;
    location.y = y;
  }

  PVector getLocation() {
    return location;
  }

  float x() {
    return location.x;
  }

  void setX(float x) {
    location.x = x;
  }

  float y() {
    return location.y;
  }

  void setY(float y) {
    location.y = y;
  }


  float yOffset() {
    return yOffset;
  }

  void setYOffset(float y) {
    yOffset = y;
  }

  float xOffset() {
    return xOffset;
  }

  void setXOffset(float x) {
    xOffset = x;
  }

  void setTrue() {
    locked = true;
  }
  void setFalse() {
    locked = false;
  }

  boolean locked() {
    return locked;
  }

  void display() {
  }

  void setButton() {
    button = true;
  }

  boolean button() {
    return button;
  }

  boolean overShape() {
    return overShape;
  }

  String getShape() {
    return "";
  }

  int getShapeNumber() {
    return shapeNumber;
  }

  String messName() {
    String name = "Square" + shapeNumber;
    return name;
  }

  void setColour(color colour) {
    col = colour;
  }
  color getColour() {
    return col;
  }

  float getSize() {
    return r;
  }
}

