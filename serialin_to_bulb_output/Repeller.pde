
class Repeller {
  PVector location;
  float r = 10;
  int life=200;
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
    PVector scaledLocation= new PVector(0,0);// =PVector.mult(location, gridSize);
    scaledLocation.x=location.x*gridX;
    scaledLocation.y=location.y*gridY;

    scaledLocation.x=scaledLocation.x/scaleX;
    scaledLocation.y=scaledLocation.y/scaleY;
    //scaledLocation =scaledLocation.div(scale);

    PVector dir = PVector.sub(scaledLocation, b.position);
    float d = dir.mag();
    stroke(100);
    //PVector scaledPosition =PVector.mult(b.position, 2);

    //ellipse(scaledLocation.x,scaledLocation.y,scaledPosition.x,scaledPosition.y);
    //d = constrain(d, 5, 10);
    dir.normalize();
    d = constrain(d, 5, 100);
    float strength=400;
    float force = 1;

    //currentTime = millis();

    //if (currentTime - prevTime > 15000) {
      //prevTime = currentTime;



      //repeller.location.x=random(width);
      //repeller.location.y=random(height);
    //}

    if (keyPressed == true) {
      force = -2 * strength / (d * d);
      prevTime = currentTime += 10000;
    } 
    dir.mult(force);
    return dir;
  }
}
