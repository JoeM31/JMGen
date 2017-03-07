/*
Joe Munday
Candidate Numbber: 24836
Creative Project
JMGen Main Class
A class for controlling a JMGen project which contains all of the mouse functions, and data sets for the project.
*/
import oscP5.*;
import netP5.*;
import g4p_controls.*;

ArrayList<ArrayList<Shape>> project;
ArrayList<Shape> shapeButtons;
ArrayList<Shape> shapeButtonsDrag;
Shape movingShape;
float wid = 1250;
float hei = 950;
OscP5 oscP5;
NetAddress supercollider;
int shapeNum = 0;
int helpNum = 0;
int newPressedCount = 0;
int timeStart = 0;
color selectedColour;
float initialColour;
ArrayList<Button> colourButtons;
ArrayList<Button> arrowButtons;
ArrayList<Integer> colours;
ArrayList<Integer> bgColours;
ArrayList<Integer> sceneTime;
ArrayList<XML> saves;
ArrayList<Indicator> indicators;
int currentScene = 0;
int circlesCounter = 0;
float radiusMul;
Button saveButton;
Button loadButton;
Button plusButton;
Button copyButton;
Button playButton;
Button playSceneButton;
Button openButtonNew;
Button openButtonLoad;
Button sceneLengthAdd;
Button sceneLengthMinus;
Button okayButton;
Button helpButton;
Button stopButton;
Button newButton;
int indicatorWidth;
boolean openScreen = true;
boolean help = false;
String currentSceneLength;
float tempo = 1.5;
int randomSeed;
String projectName = "default";
String left = "left";
String right = "right";
String front = "front";
String back = "back";
XML saveRecord;
GTextField text;
boolean newPressed = false;
boolean loadPressed = false;
XML[] saveNamesXML;
String[] saveNames;
GDropList list;
ArrayList<PImage> helpArray;
boolean playing = false;




void setup() {

  //setup method that initialises all objects 
  size((int)wid, (int)hei, P2D);
  colorMode(RGB);
  frameRate(25);

  frame.setTitle("JMGen");

  project = new ArrayList<ArrayList<Shape>>();
  project.add(new ArrayList<Shape>());
  shapeButtons = new ArrayList<Shape>();
  shapeButtonsDrag = new ArrayList<Shape>();
  colourButtons = new ArrayList<Button>();
  arrowButtons = new ArrayList<Button>();
  colours = new ArrayList<Integer>();
  bgColours = new ArrayList<Integer>();
  saves = new ArrayList<XML>();
  sceneTime = new ArrayList<Integer>();
  indicators = new ArrayList<Indicator>();
  sceneTime.add(1);
  randomSeed = (int)random(10000);

  //Arrow buttons are initialised
  arrowButtons.add( new Arrow(10, hei-60, 50, 50, 120));
  arrowButtons.get(0).setEnd();
  arrowButtons.add( new Arrow(70, hei-60, 50, 50, 120));
  arrowButtons.add( new Arrow(wid-120, hei-60, 50, 50, 120));
  arrowButtons.get(2).setRight();
  arrowButtons.add( new Arrow(wid-60, hei-60, 50, 50, 120));
  arrowButtons.get(3).setRight();
  arrowButtons.get(3).setEnd();

  sceneLengthAdd = new Button(wid-40, 130, 30, 30, 30);
  sceneLengthAdd.setPlus();
  sceneLengthMinus = new Button(wid-110, 130, 30, 30, 30);
  sceneLengthMinus.setMinus();


  //Generate Random numbers statically for the background circles
  bgColours.add((int)random(100));
  int randcount = 0;
  for (float i = 0;i<256;i++) {
    bgColours.add((int)random((int)i));
  }
  radiusMul = map(random(100), 0, 100, 0.66, 0.85);


  //Define the colours for the colour buttons
  //ColourID = 0 - RED1 KICK
  colours.add( color(178, 2, 2));
  //ColourID = 1 - RED2 SNARE
  colours.add( color(201, 85, 79));
  //ColourID = 2 - PURPLE HATS & TOMS
  colours.add( color(139, 89, 144));
  //ColourID = 3 - BLUE BASS
  colours.add( color(66, 104, 142));
  //ColourID = 4 - GREEN KEYS
  colours.add( color(69, 103, 70));
  //ColourID = 5 - YELLOW MELODYS
  colours.add( color(188, 198, 46));
  //ColourID = 6 - ORANGE HARMONIES
  colours.add( color(198, 122, 46));

  //further UI elements are initialised
  saveButton = new Button(1092, 10, 65, 30, 200);
  saveButton.setText("Save");
  loadButton = new Button(1175, 10, 65, 30, 200);
  loadButton.setText("Load");
  newButton = new Button(1010, 10, 65, 30, 200);
  newButton.setText("New");

  plusButton = new Button(wid-60, hei-120, 50, 50, 250);
  copyButton = new Button(wid-120, hei-120, 50, 50, 250);
  copyButton.copyButton();
  plusButton.setPlus();

  openButtonNew = new Button(wid/2-90, hei/2+75, 80, 50, 50);
  openButtonNew.setText("New");
  openButtonLoad = new Button(wid/2+10, hei/2+75, 80, 50, 50);
  openButtonLoad.setText("Load");

  playButton = new Button(1010, 60, 60, 50, 250);
  playButton.setMainPlay();
  playSceneButton = new Button(1100, 60, 50, 50, 250);
  playSceneButton.setPlay();
  stopButton = new Button(1190, 60, 50, 50, 250);
  stopButton.setStop();

  //Buttons for creating shapes are created
  int dist = 265;
  shapeButtons.add(new Square(10+dist, 10, 100, 0, colours.get(0)));
  shapeButtons.add(new Triangle(130+dist, 110, 100, 0, colours.get(0)));
  shapeButtons.add(new Circle(300+dist, 60, 100, 0, colours.get(0)));
  shapeButtons.add(new Hexagon(420+dist, 60, 100, 0, colours.get(0)));
  shapeButtons.add(new Star(540+dist, 60, 100, 0, colours.get(0)));
  shapeButtons.add(new Parallel(610+dist, 100, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Square(10+dist, 10, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Triangle(130+dist, 110, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Circle(300+dist, 60, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Hexagon(420+dist, 60, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Star(540+dist, 60, 100, 0, colours.get(0)));
  shapeButtonsDrag.add(new Parallel(610+dist, 100, 100, 0, colours.get(0)));

  initList();

  //Set the colour of the shape buttons
  for (Shape s: shapeButtons) {
    s.setButton();
  }

  for (Shape s: shapeButtonsDrag) {
    s.setButton();
  }

  //a shape is created to hold a place for the first shape to be moved
  movingShape = new Square(0, 0, 0, 0, 0);

  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);

  selectedColour = colours.get(0);
  initialColour = random(150)+50;
  for (int i = 0; i<colours.size();i++) {
    colourButtons.add(new Button(10+(i*35), -5, 30, 125, colours.get(i)));
  }
  colourButtons.get(0).selected();
  currentSceneLength = "" + sceneTime.get(currentScene);
  //A text field for entering project titles is initialised
  text = new GTextField(this, width/2-75, height/2+250, 150, 30, G4P.SCROLLBARS_NONE);
  text.setDefaultText("Project Title");
  text.setVisible(false);

  //further buttons are initialised
  okayButton = new Button(wid/2-40, hei/2+300, 80, 50, 50);
  okayButton.setText("Okay");


  //help section
  //help section, which is a series of images, is loaded from the data directory
  helpButton = new Button(wid/2-40, hei/2+400, 80, 50, 50);
  helpButton.setText("Help");

  helpArray = new ArrayList<PImage>();

  helpArray.add(loadImage("Help 1.png"));
  helpArray.add(loadImage("Help 2.png"));
  helpArray.add(loadImage("Help 3.png"));
  helpArray.add(loadImage("Help 4.png"));
  helpArray.add(loadImage("Help 5.png"));
  helpArray.add(loadImage("Help 5.5.png"));
  helpArray.add(loadImage("Help 6.png"));
  helpArray.add(loadImage("Help 6.5.png"));
  helpArray.add(loadImage("Help 7.png"));
  helpArray.add(loadImage("Help 8.png"));
  helpArray.add(loadImage("Help 9.png"));
  helpArray.add(loadImage("Help 10.png"));
  helpArray.add(loadImage("Help 11.png"));
  helpArray.add(loadImage("Help 12.png"));
  helpArray.add(loadImage("Help 13.png"));
}

void initList() {
  //This method loads the names of previously saved files, and adds them to an array that the application can access
  saveRecord = loadXML("saverecord.xml");
  saveNamesXML = saveRecord.getChildren("save");
  if (saveNamesXML.length !=0) {
    saveNames = new String[saveNamesXML.length];
    for (int i = 0;i<saveNamesXML.length;i++) {
      saveNames[i] = saveNamesXML[i].getString("name");
    }
println(saveNames);
    list = new GDropList (this, width/2-150, height/2+200, 300, 100);
    list.setItems(saveNames, 0);
    list.setVisible(false);
  }
}


void updateIndicators() {
  //This method ensures that the scene indicators are positioned correctly
  indicators = new ArrayList<Indicator>();
  for (int i = 0; i<project.size();i++) {
    indicators.add(new Indicator(hei - 20));
  }
}

void draw() {
  currentSceneLength = "" + sceneTime.get(currentScene);
  background(235);
  okayButton.update();
  //a boolean to determine whether to draw the help ements
  if (!help) {
    if (openScreen) {
      //welcome screen elements are drawn if openScreen boolean is true
      drawCircles((int)wid/2, (830/2)+120, (float)815, 10);
      textSize(25);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Welcome to JMGen", wid/2, 400);
      text("Please wear headphones", wid/2, 500);
      openButtonNew.display();
      openButtonNew.update();
      openButtonLoad.display();
      openButtonLoad.update();
      helpButton.display();
      helpButton.update();
    }
    if (!openScreen) {
      //if openScreen boolean is false, the rest of the elements are drawn and the application progresses to the main screen
      //most elements implement an update() method to check the mouse's position relative to them
      //most elements also implement a display() method to draw themselves
      drawCircles((int)wid/2, (830/2)+120, (float)815, 50);
      updateIndicators();

      int count = 0;
      for (Button b: colourButtons) {
        stroke(0);
        strokeWeight(0);
        if (b.getSelected()) {
          strokeWeight(4);
        }
        b.update();
        b.display();
        count++;
      }

      if (currentScene == 0) {
        arrowButtons.get(1).setGrey();
      } 
      else {
        arrowButtons.get(1).setNormal();
      }
      if (currentScene == project.size()-1) {
        arrowButtons.get(2).setGrey();
      } 
      else {
        arrowButtons.get(2).setNormal();
      }

      for (Button b: arrowButtons) {
        b.update();
        b.display();
      }


      sceneLengthAdd.display();
      sceneLengthMinus.display();
      sceneLengthAdd.update();
      sceneLengthMinus.update();
      textSize(30);
      fill(0);
      textAlign(CENTER, CENTER);
      text(currentSceneLength, wid-61, 142);


      stroke(0);
      strokeWeight(0);
      fill(205);
      rect(265, -5, 720, 125);

      fill(40);
      rect(1000, -5, wid-1000, 125);

      stroke(150);
      strokeWeight(1);

      for (Shape s : project.get(currentScene)) {
        s.update();
        s.display();
      }
      for (Shape s : shapeButtons) {
        s.setColour(selectedColour);
        s.update();
        s.display();
      }

      for (Shape s : shapeButtonsDrag) {
        s.setColour(selectedColour);
        s.update();
        s.display();
      }


      stroke(250);
      strokeWeight(3);

      for (int i = 0; i < shapeButtons.size();i++) {
        line(55+(i*120)+265, 60, 65+(i*120)+265, 60);
        line(60+(i*120)+265, 55, 60+(i*120)+265, 65);
      }


      strokeWeight(0);

      saveButton.display();
      saveButton.update();
      loadButton.display();
      loadButton.update();
      newButton.display();
      newButton.update();

      plusButton.display();
      plusButton.update();
      copyButton.display();
      copyButton.update();
      indicatorWidth = (project.size()*15 + ((project.size()-1)*5));

      for (int i = 0;i<indicators.size();i++) {
        indicators.get(i).notCurrent();
        if (i==currentScene) {
          indicators.get(i).current();
        }
        indicators.get(i).updateLocation(((wid/2)+(15/2))-(indicatorWidth/2)+(i*20));
        indicators.get(i).display();
      }
      playButton.display();
      playButton.update();

      stopButton.display();
      stopButton.update();
      playSceneButton.display();
      playSceneButton.update();
      textAlign(LEFT, CENTER);
      text(left, 0, (hei+120)/2-3);
      textAlign(RIGHT, CENTER);
      text(right, wid, (hei+120)/2-3);
      textAlign(CENTER, BOTTOM);
      text(front, wid/2, 150);
      text(back, wid/2, hei-30);
    }
    if (loadPressed) {
      list.setVisible(true);
      okayButton.update();
      okayButton.display();
    }
  }

  if (newPressed) {
    text.setVisible(true);
    okayButton.update();
    okayButton.display();
  }
  if (help) {
    helpButton.update();
    if (helpNum <helpArray.size()) {
      image(helpArray.get(helpNum), 0, 0);
    }
  }

  if (playing) {
    float played = 0.0;
    for (int i = 0;i<sceneTime.size();i++) {
      println(played);
      println(millis()-timeStart);

      if ((millis()-timeStart)> (played*1000)) {
        currentScene = i;
      }
      played += (sceneTime.get(i)*(2/tempo));
      if (currentScene == project.size()-1) {
        playing = false;
      }
    }
  }
}

void drawCircles(int x, int y, float radius, float opacity) {
  //Fractal cirlces inspired from example 8.1 in Daniel Shiffman's book 'The Nature of Code'.
  strokeWeight(0);
  fill(bgColours.get(0), bgColours.get((int)map(radius, 0, 815, 0, 255)), bgColours.get((int)map(radius, 0, 815, 0, 125)), opacity); 
  stroke(255);
  ellipse(x, y, radius, radius);

  if (radius > 25) {

    radius *= radiusMul;
    drawCircles(x, y, radius, opacity);
    circlesCounter++;
  }
  strokeWeight(1);
  line(625, 120, 625, 950);
  line(0, 535, 1250, 535);
}


void addCircle(float x, float y, color col) {
  //this method adds a circle to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Circle newCircle = new Circle(x, y, 100, shapeNum, col);
  project.get(currentScene).add(newCircle);
  OscMessage myMessage = new OscMessage("/NewCircle");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  myMessage.add(x);
  myMessage.add(y);
  //colourID
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void addTriangle(float x, float y, color col) {
  //this method adds a triangle to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Triangle newTriangle = new Triangle(x, y, 100, shapeNum, col);
  project.get(currentScene).add(newTriangle);
  OscMessage myMessage = new OscMessage("/NewTriangle");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  //colourID
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void addSquare(float x, float y, color col) {
  //this method adds a square to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Square newSquare = new Square(x, y, 100, shapeNum, col);
  project.get(currentScene).add( newSquare);
  OscMessage myMessage = new OscMessage("/NewSquare");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  myMessage.add(x);
  myMessage.add(y);
  //colourID
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void addHexagon(float x, float y, color col) {
  //this method adds a hexagon to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Hexagon newHexagon = new Hexagon(x, y, 100, shapeNum, col);
  project.get(currentScene).add(newHexagon);
  OscMessage myMessage = new OscMessage("/NewHexagon");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  myMessage.add(x);
  myMessage.add(y);
  //colourID
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void addStar(float x, float y, color col) {
  //this method adds a star to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Star newStar = new Star(x, y, 100, shapeNum, col);
  project.get(currentScene).add( newStar);
  OscMessage myMessage = new OscMessage("/NewStar");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  myMessage.add(x);
  myMessage.add(y);
  //colourID
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void addParallel(float x, float y, color col) {
  //this method adds a parallelogram to the screen, and sends an OSC message to SuperCollider to notify it of this.
  shapeNum +=1;
  Parallel newParallel = new Parallel(x, y, 100, shapeNum, col);
  project.get(currentScene).add( newParallel);
  OscMessage myMessage = new OscMessage("/NewParallel");
  int counter =0; 
  int colourID = 0;
  for (Integer i: colours) {
    if (i.equals(col)) {
      colourID = counter;
    }
    counter++;
  }
  myMessage.add(x);
  myMessage.add(y);
  //colourID
  myMessage.add(colourID);
  //uniqueID
  myMessage.add(shapeNum);
  oscP5.send(myMessage, supercollider);
}

void newProject() {
  //This method creates a new project by initialising all of the variable that correspond to the project.
  OscMessage myMessage = new OscMessage("/NewProject");
  oscP5.send(myMessage, supercollider);
  currentScene = 0;
  project = new ArrayList<ArrayList<Shape>>();
  project.add(new ArrayList<Shape>());
  sceneTime = new ArrayList<Integer>();
  sceneTime.add(1);
  randomSeed = (int)random(10000);
  OscMessage myMessage2 = new OscMessage("/RandomSeed");
  myMessage2.add(randomSeed);
  oscP5.send(myMessage2, supercollider);
}

void removeShape(Shape s) {
  //This method removes shapes that have been dragged off the screen, and sends SuperCollider an OSC message
  String removeMessage = "Remove " + s.messName();
  OscMessage myMessage = new OscMessage("/RemoveShape");
  myMessage.add(s.getShapeNumber());
  oscP5.send(myMessage, supercollider);
  project.get(currentScene).remove(s);
}

void changeSceneMessage() {
  //This method sends a message to SuperCollider with the current scene after the scene has been changed
  OscMessage myMessage = new OscMessage("/ChangeScene");
  myMessage.add(currentScene);
  oscP5.send(myMessage, supercollider);
}


void copyCurrentScene() {
  //This method duplicates all of the elements in a current scene, and adds them to a new scene to make deep copies of all of the elements.
  int copyIndex = currentScene;
  newSceneCustomTime(sceneTime.get(currentScene));

  for (Shape s : project.get(copyIndex)) {
    if (s.getShape() == "Square") {
      addSquare(s.x(), s.y(), s.getColour());
    }
    if (s.getShape() == "Triangle") {
      addTriangle(s.x(), s.y(), s.getColour());
    }
    if (s.getShape() == "Circle") {
      addCircle(s.x(), s.y(), s.getColour());
    }
    if (s.getShape() == "Hexagon") {
      addHexagon(s.x(), s.y(), s.getColour());
    }
    if (s.getShape() == "Star") {
      addStar(s.x(), s.y(), s.getColour());
    }
    if (s.getShape() == "Parallel") {
      addParallel(s.x(), s.y(), s.getColour());
    }
  }



  //OSCMESSAGE
  OscMessage myMessage = new OscMessage("/CopyScene");
  oscP5.send(myMessage, supercollider);
}

void mouseClicked() {
  //This method checks through all of the objects to see whether they have been clicked on, and then performs relevant functions.
  helpNum++;

  if (stopButton.overButton()) {
    OscMessage stopMessage = new OscMessage("/Stop");
    oscP5.send(stopMessage, supercollider);
    playing = false;
  }

  if (newButton.overButton()) {
    newPressed = true;
  }
  if (helpNum >= helpArray.size()) {
    help = false;
  }

  if (mouseButton == 39) {
    saveFrame();
  }

  if (helpButton.overButton()) {
    helpNum = 0;
    help = true;
  }

  for (Shape s : shapeButtons) {
    if (s.overShape) {
      if (s.getShape() == "Square") {
        addSquare((wid/2)-50, ((hei-120)/2)+70, selectedColour);
      } 
      if (s.getShape() == "Triangle") {
        addTriangle((wid/2)-50, ((hei-120)/2)+150, selectedColour);
      }
      if (s.getShape() == "Circle") {
        addCircle((wid/2), ((hei-120)/2)+120, selectedColour);
      } 
      if (s.getShape() == "Hexagon") {
        addHexagon((wid/2), ((hei-120)/2)+120, selectedColour);
      } 
      if (s.getShape() == "Star") {
        addStar((wid/2), ((hei-120)/2)+120, selectedColour);
      } 
      if (s.getShape() == "Parallel") {
        addParallel((wid/2)-50, ((hei-120)/2)+160, selectedColour);
      }
    }
  }

  if (sceneLengthAdd.overButton()) {
    sceneTime.set(currentScene, (sceneTime.get(currentScene)+1));
    sceneTimePlusMessage();
  }

  if (sceneLengthMinus.overButton()) {
    if (sceneTime.get(currentScene) != 0) {
      sceneTime.set(currentScene, (sceneTime.get(currentScene)-1));
      sceneTimeMinusMessage();
    }
  }

  if (openScreen) {
    if (openButtonNew.overButton) {
      newPressed = true;
      loadPressed = false;
      list.setVisible(false);
      text.setVisible(true);
    }
  }

  if (okayButton.overButton) {
    println(newPressed);
    if (newPressed) {
      println("checking if we're in here");
      projectName = text.getText();
      frame.setTitle(projectName + " - JMGen Project");
      OscMessage myMessage = new OscMessage("/RandomSeed");
      myMessage.add(randomSeed);
      oscP5.send(myMessage, supercollider);
      newPressed = false;
      if (newPressedCount != 0) {
        newProject();
      }
      newPressedCount++;
      text.setVisible(false);
    }
    if (loadPressed) {
      loadState(list.getSelectedText());
      loadPressed = false;
      list.setVisible(false);
    }
    openScreen = false;
  }

  if (okayButton.overButton) {
    if (loadPressed) {
      loadState(list.getSelectedText());
      loadPressed = false;
    }
  }
  if (copyButton.overButton) {
    copyCurrentScene();
  }

  if (openButtonLoad.overButton) {
    loadPressed = true;
    newPressed = false;
    list.setVisible(true);
    text.setVisible(false);
  }

  if (playButton.overButton()) {
    play();
  }

  if (playSceneButton.overButton()) {
    playCurrent();
  }

  if (saveButton.overButton()) {
    println("saving state");
    saveState();
  }

  if (loadButton.overButton()) {
    loadPressed = true;
    list.setVisible(true);
  }

  if (arrowButtons.get(0).overButton()) {
    currentScene = 0;
    changeSceneMessage();
  }
  if (arrowButtons.get(1).overButton()) {
    if (currentScene >= 1) {
      currentScene--;
      changeSceneMessage();
    }
  }
  if (arrowButtons.get(2).overButton()) {
    if (currentScene <= project.size()-2) {
      currentScene++;
      changeSceneMessage();
    }
  }
  if (arrowButtons.get(3).overButton()) {
    currentScene = project.size()-1;
    changeSceneMessage();
  }

  if (plusButton.overButton()) {
    newScene();
  }

  int count = 0;
  for (Button b: colourButtons) {
    if (b.overButton()) {
      selectedColour = colours.get(count);
      colourButtons.get(count).selected();
      for (int f = 0; f<colourButtons.size();f++) {
        if (f != count) {
          colourButtons.get(f).notSelected();
        }
      }
    }
    count++;
  }
}

void saveState() {
  //This method saves the state of a current project to an XML file.
  XML newSave = saveRecord.addChild("save");
  newSave.setString("name", projectName + " JMGen Project.xml");
  int sceneNum = 1;
  //saves.add( new XML("Scene" + sceneNum + ".xml"));
  XML save = new XML("JMGenSave");
  save.setInt("randomSeed", randomSeed);
  save.setString("projectName", projectName);
  for (int i = 0; i <project.size();i++) {
    //for(int i = 0; i <sceneCount;i++){


    XML sceneSave = save.addChild("scene");
    sceneSave.setFloat("time", sceneTime.get(i));
    sceneSave.setInt("sceneNumber", i);
    for (Shape s: project.get(i)) {


      XML newChild = sceneSave.addChild("shape");
      newChild.setContent(s.getShape());
      newChild.setString("type", s.getShape());
      newChild.setInt("id", s.getShapeNumber());
      newChild.setFloat("locationx", s.x());
      newChild.setFloat("locationy", s.y());
      newChild.setInt("colour", s.getColour());
      newChild.setInt("size", (int)s.getSize());
    }
  }


  saveXML(save, projectName + " JMGen Project.xml");
  saveXML(saveRecord, "saverecord.xml");
  initList();
}

void loadState(String xmlName) {
  //This method loads a previously saved state from an XML file
  OscMessage myMessage = new OscMessage("/Load");
  oscP5.send(myMessage, supercollider);
  XML load = loadXML(xmlName);
  XML[] children = load.getChildren("scene");
  ArrayList<Shape> currentTest = new ArrayList<Shape>();
  project = new ArrayList<ArrayList<Shape>>();
  sceneTime = new ArrayList<Integer>();
  projectName = load.getString("projectName"); 
  randomSeed = load.getInt("randomSeed");
  shapeNum = 0;

  for (int i = 0; i < children.length; i++) {
    OscMessage sceneMessage = new OscMessage("/NewScene");
    oscP5.send(sceneMessage, supercollider);
    project.add(new ArrayList<Shape>());
    currentScene = i;
    sceneTime.add((int)children[i].getFloat("time"));
    OscMessage timeMessage = new OscMessage("/SceneTimeSet");
    timeMessage.add((int)children[i].getFloat("time"));
    oscP5.send(timeMessage, supercollider);
    //oscmessage set time
    XML[] sceneShapes = children[i].getChildren("shape");
    for (int j = 0; j<sceneShapes.length;j++) {
      if (sceneShapes[j].getString("type").equals("Square")) {
        addSquare(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
      if (sceneShapes[j].getString("type").equals("Triangle")) {
        addTriangle(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
      if (sceneShapes[j].getString("type").equals("Circle")) {
        addCircle(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
      if (sceneShapes[j].getString("type").equals("Star")) {
        addStar(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
      if (sceneShapes[j].getString("type").equals("Hexagon")) {
        addHexagon(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
      if (sceneShapes[j].getString("type").equals("Parallel")) {
        addParallel(sceneShapes[j].getFloat("locationx"), sceneShapes[j].getFloat("locationy"), sceneShapes[j].getInt("colour"));
      }
    }
  }
}


void newScene() {
  //This methods adds a new scene to the project
  project.add(new ArrayList<Shape>());
  sceneTime.add(1);
  currentScene = project.size()-1;
  OscMessage myMessage = new OscMessage("/NewScene");
  oscP5.send(myMessage, supercollider);
}

void newSceneCustomTime(Integer time) {
  //This method is used in recreating scenes to copy them.
  project.add(new ArrayList<Shape>());
  sceneTime.add(time);
  currentScene = project.size()-1;
  OscMessage myMessage = new OscMessage("/NewSceneCustomTime");
  myMessage.add(time);
  oscP5.send(myMessage, supercollider);
}

void play() {
  //This method starts off the play process when the play button has been pressed.
  OscMessage myMessage = new OscMessage("/Play");
  oscP5.send(myMessage, supercollider);
  playing = true;
  currentScene = 0;
  timeStart = millis();
}

void playCurrent() {
  //This method starts off the play current scene process when the play current scene button has been pressed.
  OscMessage myMessage = new OscMessage("/PlayCurrent");
  oscP5.send(myMessage, supercollider);
}

void mousePressed() {
  //This method tracks which mouse has the mouse over it when it has been pressed.
  for (Shape s : project.get(currentScene)) {
    if (s.overShape) {
      s.setTrue();
      movingShape = s;
    } 
    else {
      s.setFalse();
    }
    s.setXOffset((pmouseX-s.x()));
    s.setYOffset((pmouseY-s.y()));
  }

  for (Shape s : shapeButtonsDrag) {
    if (s.overShape) {
      s.setTrue();
      movingShape = s;
    } 
    else {
      s.setFalse();
    }
    s.setXOffset((pmouseX-s.x()));
    s.setYOffset((pmouseY-s.y()));
  }
}


void mouseDragged() {
  //this method tracks where the mouse is when it's being dragged from a position where it was over a shape.
  if (movingShape.locked()) {
    movingShape.setX((pmouseX-movingShape.xOffset));
    movingShape.setY((pmouseY-movingShape.yOffset));

    OscMessage myMessage = new OscMessage("/MoveShape");
    myMessage.add(movingShape.getShapeNumber());
    myMessage.add(movingShape.x());
    myMessage.add(movingShape.y());
    oscP5.send(myMessage, supercollider);
  }
}

void mouseReleased() {
  //This method performs a function depending on where the shape was ultimately left.
  Shape toBeRemoved = new Circle(-300, -300, 0, 0, 0);
  Shape toBeCompared = new Circle(-300, -300, 0, 0, 0);

  if (movingShape.button()) {
    if (movingShape.getShape().equals("Square")) {
      addSquare(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(0).setX(275);
      shapeButtonsDrag.get(0).setY(10);
    }
    if (movingShape.getShape().equals("Triangle")) {
      addTriangle(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(1).setX(395);
      shapeButtonsDrag.get(1).setY(110);
    }
    if (movingShape.getShape().equals("Circle")) {
      addCircle(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(2).setX(565);
      shapeButtonsDrag.get(2).setY(60);
    }
    if (movingShape.getShape().equals("Hexagon")) {
      addHexagon(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(3).setX(685);
      shapeButtonsDrag.get(3).setY(60);
    }
    if (movingShape.getShape().equals("Star")) {
      addStar(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(4).setX(805);
      shapeButtonsDrag.get(4).setY(60);
    }
    if (movingShape.getShape().equals("Parallel")) {
      addParallel(movingShape.x(), movingShape.y(), movingShape.getColour());
      shapeButtonsDrag.get(5).setX(875);
      shapeButtonsDrag.get(5).setY(100);
    }
  }

  for (Shape s : project.get(currentScene)) {
    s.setFalse();
    if (s.x() > wid || s.y() <120 || s.x() <0 || s.y()<0) {
      toBeRemoved = s;
    }
  }
  if (!toBeRemoved.equals(toBeCompared)) {
    removeShape(toBeRemoved);
  }

  OscMessage myMessage = new OscMessage("/MouseReleased");
  oscP5.send(myMessage, supercollider);
}

void sceneTimePlusMessage() {
  //this method sends a message to SuperCollider telling it that the scene time has been increased.
  OscMessage myMessage = new OscMessage("/SceneTimePlus");
  oscP5.send(myMessage, supercollider);
}

void sceneTimeMinusMessage() {
  //this method sends a message to SuperCollider telling it that the scene time has been decreased.
  OscMessage myMessage = new OscMessage("/SceneTimeMinus");
  oscP5.send(myMessage, supercollider);
}

void oscEvent(OscMessage theOscMessage) {
  //this method listens for a startup message from SuperCollider containing the language port and the tempo of the project.
  if (theOscMessage.addrPattern().equals("/startup")) {
    supercollider = new NetAddress("127.0.0.1", theOscMessage.get(0).intValue());
    tempo = theOscMessage.get(1).floatValue();
  }
  println(tempo);
}

void exit() {
  //This line overwrites Processing's exit() method and sends a message to SuperCollider so it can quit simultaneously.
  OscMessage myMessage = new OscMessage("/Close");
  oscP5.send(myMessage, supercollider);
  super.exit();
}

