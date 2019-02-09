int scale=40;
int gridX=11;
int gridY=20;

import processing.serial.*;
Serial myPort;  // The serial port

Table table;
Bulb[] bulbs= new Bulb[226];
PImage img;

void settings() {
  size(scale*gridX, scale*gridY); //scale*gridSize
  //myPort = new Serial(this, Serial.list()[0], 9600);
  table = loadTable("esps1.csv", "header");
  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {

    int id = row.getInt("id");
    String url = row.getString("url");

    //println(url + " | " + id);
    bulbs[id]=new Bulb(0, 0, id, url);
  }

  //link id to position
  int count=0;
  for (int i=1; i<gridX; i++) {
    for (int j=1; j<gridY; j++) {
      bulbs[count].x=i*scale;
      bulbs[count].y=j*scale;
      count++;
    }
  }
}


void setup() {
}

void draw() {
  background(20);
  drawGrid();

  for (int i=0; i<226; i++) {
    bulbs[i].update();
    bulbs[i].draw();
  }
}

void readSerial() {
  while (myPort.available() > 0) {
    int inByte = myPort.read();
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
}


class Bulb {
  int x;
  int y;
  int bulbId;
  String url;
  boolean on;

  Bulb(int _x, int _y, int _id, String _url) {
    x=_x;
    y=_y;
    bulbId=_id;
    url=_url;
  }

  void draw() {
    ellipseMode(CENTER);
    noStroke();
    if (on) {
      fill(255);
      loadURL();
      on=false;
    } else {
      fill(50);
    }
    ellipse(x, y, scale/2, scale/2);
    pingNeighbor();
  }

  void pingNeighbor() {
  }

  void loadURL() {
    println(bulbId);
    //img= loadImage(url);
  }

  void update() {
    if (mousePressed) {
      if (mouseX>x-scale/2 && mouseX<x+scale/2 && mouseY>y-scale/2 && mouseY<y+scale/2) 
        on=true;
    }
  }
}
