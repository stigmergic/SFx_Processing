public class Boids {
  ArrayList boids;

  public Boids() {
    boids = new ArrayList();
  }  

  int size() {
    return boids.size();  
  }

  void addBoid() {
    boids.add(new Boid(new Vector(width/2, height/2)));     
  }

  void addBoid(Vector v) {
    boids.add(new Boid(v));  
  }

  void addBoid(Boid b) {
    boids.add(b);  
  }

  void draw() {
    Boid boid;
    if (drawhistory) {
      //strokeWeight(2);

      for (int j=1; j<historyLength; j++) {
        float f = float(j)/historyLength + 0.1;

        for (int i=0; i<boids.size(); i++) {
          boid = (Boid) boids.get(i);
          if (boid.history.size()>j) {
            stroke(red(boid.c)*f, green(boid.c)*f, blue(boid.c)*f);
            line((Vector) boid.history.get(j-1), (Vector) boid.history.get(j));
          }
        }     

      }
    }
    
    
    for (int i=0; i<boids.size(); i++) {
      boid = (Boid) boids.get(i);
      boid.draw();    
    }     
  }

  void step() {
    update();
    move();
  }

  void update() {
    Boid boid;

    for (int i=0; i<boids.size(); i++) {
      boid = (Boid) boids.get(i);
      boid.resetInfluences();
    }

    for (int i=0; i<boids.size(); i++) {
      boid = (Boid) boids.get(i);

      for (int j=0; j<boids.size(); j++) {
        if (i == j) continue;
        boid.calcBoidBoidInfluences((Boid) boids.get(j));
      }

      boid.calcBoidEnvironmentInfluences();

      boid.applyInfluences();
    }
  }


  void move() {
    Boid boid;
    for (int i=0; i<boids.size(); i++) {
      boid = (Boid) boids.get(i);
      boid.step();    
    }       
  }

  void removeAll() {
    boids.clear();  
  }

  void removeOne() {
    if (boids.size()>0) {
      boids.remove(boids.size()-1);
    }  
  }

  void setVelocity(Vector v) {
    Boid b;
    for (int i=0; i<boids.size(); i++) {
      b = (Boid) boids.get(i);
      b.velocity = v.copy();
    }  
  }

  void setRandomLocation() {
    Boid b;
    for (int i=0; i<boids.size(); i++) {
      b = (Boid) boids.get(i);
      b.location.set(random(width), random(height));
      ;
      b.velocity.set(0,0);
    }  
  }

  void addInfluence(Vector v) {
    Boid b;
    for (int i=0; i<boids.size(); i++) {
      b = (Boid) boids.get(i);
      b.velocity.add(v);
    }  
  }
}






