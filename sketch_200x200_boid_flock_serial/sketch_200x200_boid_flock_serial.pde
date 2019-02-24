Flock flock;
int scale=40;
int gridSize=15;

import processing.serial.*;
Serial myPort;  // The serial port

Table table;

String[] esp = new String[226];//1-225
Repeller repeller;


void settings() {
  size(scale*gridSize, scale*gridSize); //scale*gridSize
  //myPort = new Serial(this, Serial.list()[0], 9600);
  table = loadTable("esps1.csv", "header");
  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {

    int id = row.getInt("id");
    String url = row.getString("url");

    //println(url + " | " + id);
    esp[id]=url;//1-225
    //println(esp[id]);
  }
}


void setup() {
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 3; i++) {
    flock.addBoid(new Boid(width/2, height/2));
  }
  repeller = new Repeller(width/3, height/3);
  //frameRate(28);
}

void draw() {


  background(180);
  drawGrid();
  flock.run();
  flock.applyRepeller(repeller);
  repeller.display();
}

void readSerial() {
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    println(inByte);
  }
}

void drawGrid() {
  stroke(55);

  for (int i=0; i<gridSize; i++) {
    line(i*scale, 0, i*scale, height);
  }
  for (int i=0; i<gridSize; i++) {
    line(0, i*scale, width, i*scale);
  }

  for (int i=1; i<gridSize; i++) {
    for (int j=1; j<gridSize; j++) {

      ellipseMode(CENTER);
      noStroke();
      fill(255);
      ellipse(i*scale, j*scale, scale/2, scale/2);
    }
  }
}
// Add a new boid into the System
void mousePressed() {
  //flock.addBoid(new Boid(mouseX,mouseY));
  //for (int i = 0; i < 20; i++) {
  //  flock.addBoid(new Boid(mouseX*gridSize/scale, mouseY*gridSize/scale));
  //}

  repeller.location.x=mouseX;
  repeller.location.y=mouseY;
  repeller.life=100;
}

class Bulb {
  int x;
  int y;
  int id;
  String url;

  Bulb(int _x, int _y, int _id, String _url) {
    x=_x;
    y=_y;
    id=_id;
    url=_url;
  }

  void drawBulb() {
    ellipseMode(CENTER);
    noStroke();
    fill(50);
    ellipse(x, y, scale/2, scale/2);
  }
}


// The Flock (a list of Boid objects)
class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }
  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    //cull offscreen boids
    //for (Boid b : boids) {
    //  if (b.position.x>=width || b.position.x<=0 || b.position.y>=height || b.position.y<=0) {
    //    removeBoid(b);
    //    break;
    //  }
    //}
  }
  void addBoid(Boid b) {
    boids.add(b);
  }
  void removeBoid(Boid b) {
    boids.remove(b);
  }

  void applyRepeller(Repeller r) {
    for (Boid b : boids) {
      PVector force = r.repel(b);
      if (r.life>0) {
        b.applyForce(force);
      }
    }
  }
}



class Repeller {
  PVector location;
  float r = 10;
  int life=100;
  Repeller(float x, float y) {
    location = new PVector(x, y);
  }

  void display() {
    stroke(255);
    fill(255);
    ellipse(location.x, location.y, r/2, r/2);
    life--;
  }


  long currentTime;
  long prevTime;

  PVector repel(Boid b) {
    PVector scaledLocation =PVector.mult(location, gridSize);
    scaledLocation =scaledLocation.div(scale);

    PVector dir = PVector.sub(scaledLocation, b.position);
    float d = dir.mag();
    stroke(100);
    PVector scaledPosition =PVector.mult(b.position, 2);

    //ellipse(scaledLocation.x,scaledLocation.y,scaledPosition.x,scaledPosition.y);
    //d = constrain(d, 5, 10);
    dir.normalize();
    d = constrain(d, 5, 100);
    float strength=400;
    float force = 1;
    
    currentTime = millis();

    if (currentTime - prevTime > 15000) {
      prevTime = currentTime;

      repeller.location.x=mouseX;
      repeller.location.y=mouseY;

      //repeller.location.x=random(width);
      //repeller.location.y=random(height);
      repeller.life=100;
    }

    if (keyPressed == true) {
      force = -2 * strength / (d * d);
      prevTime = currentTime += 10000;
    } 
    dir.mult(force);
    return dir;
  }
}