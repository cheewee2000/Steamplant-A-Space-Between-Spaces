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
  //println(Serial.list());
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
  for (int i=1; i<gridY; i++) {
    for (int j=1; j<gridX; j++) {
      bulbs[count].xpos=j*scaleX;
      bulbs[count].ypos=i*scaleY;
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
      bulbs[constrain(cell*6+int(random(-6,0)),0,226)].drawLine();
  
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



int returnCell(int x, int y) {
  int cell=0;

  //coordinate the cell numbers
  if (x == 1 && y == 1) {
    cell = 0;
  }
  if (x==2 && y == 1) {
    cell =1;
  }
  if (x==3 && y == 1) {
    cell=2;
  }
  if (x==4 && y == 1) {
    cell=3;
  }
  if (x==5 && y == 1) {
    cell=4;
  }
  if (x==6 && y == 1) {
    cell=5;
  }

  if (x == 1 && y == 2) {
    cell = 6;
  }
  if (x==2 && y == 2) {
    cell =7;
  }
  if (x==3 && y == 2) {
    cell=8;
  }
  if (x==4 && y == 2) {
    cell=9;
  }
  if (x==5 && y == 2) {
    cell=10;
  }
  if (x==6 && y == 2) {
    cell=11;
  }


  if (x == 1 && y == 3) {
    cell = 12;
  }
  if (x==2 && y == 3) {
    cell =13;
  }
  if (x==3 && y == 3) {
    cell=14;
  }
  if (x==4 && y == 3) {
    cell=15;
  }
  if (x==5 && y == 3) {
    cell=16;
  }
  if (x==6 && y == 3) {
    cell=17;
  }


  if (x == 1 && y == 4) {
    cell = 18;
  }
  if (x==2 && y == 4) {
    cell =19;
  }
  if (x==3 && y == 4) {
    cell=20;
  }
  if (x==4 && y == 4) {
    cell=21;
  }
  if (x==5 && y == 4) {
    cell=22;
  }
  if (x==6 && y == 4) {
    cell=23;
  }

  if (x == 1 && y == 5) {
    cell = 24;
  }
  if (x==2 && y == 5) {
    cell =25;
  }
  if (x==3 && y == 5) {
    cell=26;
  }
  if (x==4 && y == 5) {
    cell=27;
  }
  if (x==5 && y == 5) {
    cell=28;
  }
  if (x==6 && y == 5) {
    cell=29;
  }

  if (x == 1 && y == 6) {
    cell = 30;
  }
  if (x==2 && y == 6) {
    cell =31;
  }
  if (x==3 && y == 6) {
    cell=32;
  }
  if (x==4 && y == 6) {
    cell=33;
  }
  if (x==5 && y == 6) {
    cell=34;
  }
  if (x==6 && y == 6) {
    cell=35;
  }
  return cell;
}
