
//--------------------------- Obstacles -----------
public class Obstacles {
  ArrayList  obstacles;
  ArrayList sources;
  ArrayList sinks;
  ArrayList lostBoids;

  Vector lastLocation = null;

  public Obstacles() {
    obstacles = new ArrayList();
    sources = new ArrayList();
    sinks = new ArrayList();
    lostBoids = new ArrayList();   
  }

  void add(Obstacle o) {
    obstacles.add(o); 
  }

  void add(float x, float y) {
    Vector newLocation = new Vector(x,y);
    if (lastLocation == null) {
      //add(new Obstacle(newLocation));
      add(new LineObstacle(newLocation, newLocation));
    } 
    else {
      add(new LineObstacle(lastLocation, newLocation)); 
    } 
    lastLocation = newLocation;
  }

  void addSource(float x, float y) {
    Obstacle o = new SourceObstacle(x,y);
    add(o);
    sources.add(o); 
  }


  void addSink(float x, float y) {
    Obstacle o = new SinkObstacle(x,y);
    add(o);
    sinks.add(o); 
  } 

  void draw() {
    Obstacle o;
    Vector v = null;
    for (int i=0; i<obstacles.size(); i++) {
      o = (Obstacle) obstacles.get(i);
      o.draw();

      //Draw a line between obstacles
      //stroke(100);
      //if (v != null) line(v,o.location);
      //v = o.location;  
    }
  }  

  Vector getInfluenceFor(Boid b) {
    Vector v = new Vector();

    Obstacle o;
    for (int i=0; i<obstacles.size(); i++) {
      o = (Obstacle) obstacles.get(i);
      v.add(o.getInfluenceFor(b));
    }

    return v;
  }  

  void doSourceSink() {
    Boid b;
    SinkObstacle sink;
    for (int i=0; i<sinks.size(); i++) {
      sink = (SinkObstacle) sinks.get(i);
      Vector influence;
      for (int j=0; j<boids.boids.size(); j++) {
        b = (Boid) boids.boids.get(j);
        influence = sub(sink.location, b.location);

        if (influence.magnitude() <= obstacleSize) {
          lostBoids.add(boids.boids.get(j));
          boids.boids.remove(j);
          j--;
        }
      }
    }

    SourceObstacle source;
    for (int i=0; i<sources.size(); i++) {
      source = (SourceObstacle) sources.get(i);
      if (lostBoids.size()>0 && random(sources.size())<1.0) {
        b = (Boid) lostBoids.get(0);
        b.location = source.location.copy();
        boids.addBoid(b);
        lostBoids.remove(0);
      }
    } 
  }  

  void clear() {
    lastLocation = null;
    obstacles.clear();
    sources.clear();
    sinks.clear();
  }
}


