
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
