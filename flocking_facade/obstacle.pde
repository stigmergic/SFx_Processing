public class Obstacle {
  public Vector location;
  color c;

  public Obstacle(Vector _location) {
    location = _location;
    c = color(0,100,random(100));      
  }

  public Obstacle(float x, float y) {
    this(new Vector(x,y));
  }

  void draw() {
    stroke(c);
    noFill();
    ellipse(location, obstacleSize*2);    
    noStroke();
    fill(c);
    ellipse(location, obstacleSize/4);
  }

  Vector getInfluenceFor(Boid b) {
    Vector influence = sub(location, b.location);

    if (influence.magnitude() > obstacleSize) {
      influence.set(0,0);
    }

    return influence;
  }
}

class SourceObstacle extends Obstacle {
  public SourceObstacle(float x, float y) {
    super(x,y);  
  }
  
}

class SinkObstacle extends Obstacle {
  public SinkObstacle(float x, float y) {
    super(x,y);  
  }
  
}

class LineObstacle extends Obstacle {
  Vector location1,location2;

  color c;


  public LineObstacle (Vector v1, Vector v2) {
    super( (v1.x + v2.x) / 2, (v1.y + v2.y) / 2);
    location1 = v1;
    location2 = v2;
    c = color(0,100,50);  
  }

  public LineObstacle(float x1, float y1, float x2, float y2) {
    this(new Vector(x1,y1), new Vector(x2,y2));  
  }

  void draw() {
    stroke(c);
    noFill();
    line(location2, location1);
    ellipse(location1, 4);
    ellipse(location2, 4);
    
  }

  Vector getVectorTo(Vector v) {
    Vector lineVector = sub(location1, location2);
    float lineMag = lineVector.magnitude();

    float ff =  (( ( v.x - location1.x ) * ( lineVector.x ) ) + ( ( v.y - location1.y ) * ( lineVector.y ) )) / ( lineMag * lineMag );

    ff = constrain(ff,0,1.0);

    float intersecx = location1.x + int(ff * (lineVector.x));
    float intersecy = location1.y + int(ff * (lineVector.y));
    return new Vector(v.x-intersecx, v.y-intersecy);
  }

  Vector getInfluenceFor(Boid b) {
    Vector influence = getVectorTo( b.location);

    float l = influence.magnitude(); 
    if  ( l > obstacleSize) {
      influence.set(0,0);
    } else {
      influence.normalize();
      influence.scale(obstacleSize/l*100);  
    }

    return influence;
  }  
}

