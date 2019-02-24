//Che-Wei Wang for Joe Morris
//Steamplant Residency : A-Space-Between-Spaces

//bulb control + simulation

//try
//flocking with hits makes flock go away
Flock flock;
Repeller repeller;


//scale to window

int scaleX=60;
int scaleY=40;


//bulb grid size
int gridX=11;
int gridY=19;

//muondetectorgrid;
int mGrid=6;

PVector lastPos;

//last grid position
int lastbulbId=0;
//int y1=18;

import processing.serial.*;
Serial myPort;


//bulb cvs table
Table table;
Bulb[] bulbs= new Bulb[226];

//pimage to ping url of esp
PImage img;

void settings() {
  size(scaleX*gridX, scaleY*gridY); //scale*gridSize

  //serial
  println(Serial.list());
  //myPort = new Serial(this, Serial.list()[4], 500000);
  //myPort.bufferUntil('\n');

  //load csv
  table = loadTable("esps1.csv", "header");
  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    int id = row.getInt("id");
    String url = row.getString("url");
    //println(url + " | " + id);

    //link url to bulb id, construct bulb obj
    bulbs[id]=new Bulb(0, 0, id, url);
  }

  //link id to position on grid
  int count=0;
  int yCount=0;
  for (int i=1; i<gridY; i++) {
    yCount++;
    for (int j=1; j<gridX; j++) {
      if (yCount%2==1) {
        bulbs[count].xpos=j*scaleX;
        bulbs[count].ypos=i*scaleY;
      } else {
        bulbs[count].xpos=width-j*scaleX;
        bulbs[count].ypos=i*scaleY;
      }
      count++;
    }
  }

  lastPos = new PVector(width/2, height/2);
}


void setup() {
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 4; i++) {
    flock.addBoid(new Boid(60, 60));
  }
  repeller = new Repeller(width/3, height/3);
  //frameRate(28);
}

void draw() {
  background(180);

  //draw background grid
  drawGrid();

  //update and draw bulbs
  for (int i=0; i<226; i++) {
    bulbs[i].update();
    bulbs[i].draw();
  }

  flock.run();
  flock.applyRepeller(repeller);
  repeller.display();
}


void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // split the string on the commas and convert the resulting substrings
    // into an integer array:
    int[] coordinates = int(split(inString, ","));
    // if the array has at least three elements, you know you got the whole
    // thing.  Put the numbers in the color variables:
    if (coordinates.length >= 2) {
      // map them to the range 0-255:
      int cell= returnCell(coordinates[0], coordinates[1]);
      //println("Coordinate = " + coordinates[0] + "," + coordinates[1] + " Cell = " + cell);
      //println(cell);
      bulbs[constrain(cell*6+int(random(-6, 0)), 0, 226)].drawLine();
    }
  }
}





void drawGrid() {
  stroke(55);
  for (int i=0; i<gridX; i++) {
    //line(i*scaleX, 0, i*scaleX, height);
  }
  for (int i=0; i<gridY; i++) {
    line(0, i*scaleY, width, i*scaleY);
  }
  //stroke(105);

  //int margin=0;
  //for (int i=0; i<mGrid+1; i++) {
  //  line(margin+i*(width-margin*2)/(mGrid), 0, margin+i*(width-margin*2)/(mGrid), height);
  //}
  //for (int i=0; i<mGrid+1; i++) {
  //  line(0, margin+i*(height-margin*2)/(mGrid), width, margin+i*(height-margin*2)/(mGrid));
  //}
}


void mousePressed() {
  //flock.addBoid(new Boid(mouseX,mouseY));
  //for (int i = 0; i < 20; i++) {
  //  flock.addBoid(new Boid(mouseX*gridSize/scale, mouseY*gridSize/scale));
  //}

  repeller.location.x=mouseX;
  repeller.location.y=mouseY;
  repeller.life=200;
}

int returnBulb(int c) {
  int bulb=0;
  switch (c) {
  case 0:
    bulb=pickOne(0, 1, 19, 18, 20, 21);
    break;
  case 1:
    bulb=pickOne(2, 3, 17, 16, 22, 23);
    break;
  }


  return bulb;
}

int pickOne( int a, int b, int c, int d, int e, int f) {


  int [] cluster= {a, b, c, d, e, f};

  return cluster[int( random(0, 6)) ];
}



int returnCell(int x, int y) {
  int sensorX=5;
  int sensorY=6;
  int cell=x+sensorX*y;
  return cell;
}
