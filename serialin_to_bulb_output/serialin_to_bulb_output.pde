//Che-Wei Wang for Joe Morris
//Steamplant Residency : A-Space-Between-Spaces

//bulb control + simulation

//scale to window
int scale=40;

//bulb grid size
int gridX=12;
int gridY=21;

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
  size(scale*gridX, scale*gridY); //scale*gridSize
  //myPort = new Serial(this, Serial.list()[0], 9600);

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
      bulbs[count].xpos=j*scale;
      bulbs[count].ypos=i*scale;
      count++;
    }
  }

  lastPos = new PVector(width/2, height/2);
}


void setup() {
}

void draw() {
  background(20);

  //draw background grid
  drawGrid();

  //update and draw bulbs
  for (int i=0; i<226; i++) {
    bulbs[i].update();
    bulbs[i].draw();
  }
}

void readSerial() {
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    //set bulb on if inbyte matches bulb
    bulbs[inByte].on=true;
    println(inByte);
  }
}

void drawGrid() {
  stroke(55);
  for (int i=0; i<gridX; i++) {
    line(i*scale, 0, i*scale, height);
  }
  for (int i=0; i<gridY; i++) {
    line(0, i*scale, width, i*scale);
  }
  stroke(105);

  int margin=25;
  for (int i=0; i<mGrid+1; i++) {
    line(margin+i*(width-margin*2)/(mGrid), 0, margin+i*(width-margin*2)/(mGrid), height);
  }
  for (int i=0; i<mGrid+1; i++) {
    line(0, margin+i*(height-margin*2)/(mGrid), width, margin+i*(height-margin*2)/(mGrid));
  }
}
