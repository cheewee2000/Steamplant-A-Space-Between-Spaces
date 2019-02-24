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
int mGridX=5;
int mGridY=6;

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
  myPort = new Serial(this, Serial.list()[4], 115200);
  myPort.bufferUntil('\n');

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
  int count=1;
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
      //int cell= returnCell(coordinates[0], coordinates[1]);
      println("Coordinate = " + coordinates[0] + "," + coordinates[1] );
      //println(cell);
      //bulbs[constrain(cell*6+int(random(-6, 0)), 0, 226)].drawLine();
      repeller.location.x=width/coordinates[0];
      repeller.location.y=height/coordinates[1];
      repeller.life=200;
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

  stroke(255);
  noFill();

  int marginX=31;
  int marginY=25;

  for (int i=0; i<mGridY; i++) {
    for (int j=0; j<mGridX; j++) {
      int rectX=marginX+j*(width-marginX*2)/(mGridX);
      int rectY=marginY+i*(height-marginY*2)/(mGridY);
      int w= (width-marginX*2)/mGridX;
      int h= (height-marginY*2)/mGridY;

      rect(rectX, rectY, w, (height-marginY*2)/mGridY);
    }
  }
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
