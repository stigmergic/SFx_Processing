
public class Boid {
  Vector location = new Vector();
  Vector velocity = new Vector();
  Vector influence = new Vector();
  ArrayList history = new ArrayList();

  //The vectors that are combined to form the influence of the boid
  Vector avoid;
  Vector center;
  Vector align;

  Vector noise;
  Vector mouse;
  Vector obstacleInfluence;

  //The maximum speed of the boid
  float speed;

  //The color of the boid
  color c = color(255);

  boolean highlight = false;

  public Boid(Vector v) {
    location = v;
    setRandomSpeed();
  }

  public void setRandomSpeed() {
    float r = random(maxSpeed - minSpeed);
    //float r = (random(1.0)<0.5) ? 0 : maxSpeed - minSpeed;

    speed = minSpeed + r; 

    c = color(255 * (speed-minSpeed)/(maxSpeed - minSpeed),  (255 * (speed-minSpeed)/(maxSpeed - minSpeed) + 255 * (1 - (speed - minSpeed)/(maxSpeed - minSpeed))) / 4 , 255 * (1 - (speed - minSpeed)/(maxSpeed - minSpeed)));
  }

  public Boid(float x, float y, float vx, float vy) {
    location = new Vector(x, y);
    velocity = new Vector(vx, vy);  
  }

  void step() {
    location.add(velocity);

    constrainToScreen();

    /*
    if (random(3)<1) {
     history.add(location.copy());
     }
     */
    history.add(location.copy());

    while(history.size()>historyLength) history.remove(0);  
  }

  void constrainToScreen() {
    float ox = location.x;
    float oy = location.y;

    location.x = constrain(location.x, boidSize/2, width - boidSize/2);
    location.y = constrain(location.y, boidSize/2, height - boidSize/2);

    if (ox != location.x) {
      velocity.x = 0;
      location.x += random(1.0) - 0.5;
    }
    if (oy != location.y) {
      velocity.y = 0;  
      location.y += random(1.0) - 0.5;
    }  
  }

  void draw() {  
    //strokeWeight(2);

    if (showneighborhood) {
      noFill();
      stroke(100);
      ellipse(location.x, location.y, avoidanceRadius, avoidanceRadius);
      stroke(255,0,0);
      ellipse(location.x, location.y, neighborhoodRadius, neighborhoodRadius);
    }

    if (showagent) {
      noStroke();
      if (highlight) {
        fill(getHighlightColor());
      } else {
        fill(c);
      }
      ellipse(location.x, location.y, boidSize, boidSize);
    }


    if (showvelocity) {
      stroke(255,255,0);
      //stroke(100);
      if (boidSize*maxSpeed > 10) {
        Vector perp = new Vector(-velocity.y, velocity.x);
        perp.normalize();

        float endX = location.x+velocity.x*boidSize/2;
        float endY = location.y + velocity.y*boidSize/2;  

        line( endX, endY, endX - velocity.x*boidSize/6 - perp.x*boidSize/6, endY - velocity.y*boidSize/6 - perp.y*boidSize/6);  
        line( endX, endY, endX - velocity.x*boidSize/6 + perp.x*boidSize/6, endY - velocity.y*boidSize/6 + perp.y*boidSize/6);                    
      } 

      line( location.x, location.y, location.x+velocity.x*boidSize/2, location.y + velocity.y*boidSize/2);  

    }

    if (showinfluence) {
      stroke(0,255,0);
      //stroke(0);
      line(location.x, location.y, location.x+influence.x*boidSize*1.5, location.y + influence.y*boidSize*1.5);  
    }
  }

  void calcBoidBoidInfluences(Boid boidJ) {
    float d = distance(location, boidJ.location);
    if (d<boidSize) {
      highlight = true;  
    }

    if (d <= avoidanceRadius) {
      avoid.add(direction(boidJ.location, location));
    } 
    else if (d <= neighborhoodRadius) {
      center.add(sub(location, boidJ.location));
      align.add(boidJ.velocity.copy());
    }
  }

  void calcBoidEnvironmentInfluences() {
    if (avoidmouse) {
      Vector mouseLocation = new Vector(mouseX, mouseY);
      mouse = sub( mouseLocation, location);
      float distance = mouse.magnitude();

      if (distance>mouseRadius+boidSize/2) {
        mouse.set(0,0);
      }
    }

    obstacleInfluence  = obstacles.getInfluenceFor(this);

    noise = randomUnitVector();
  }

  void calculateInfluence() {
    noise.normalize().scale(noiseWeight);

    avoid.normalize().scale(avoidanceWeight);

    /*
    if (highlight) {
     influence.add(avoid);
     influence.add(velocity.copy().normalize().scale(oldWeight));     
     influence.normalize().scale(speed * (1 - oldWeight));
     return;  
     }
     */

    center.normalize().scale(centerWeight);
    align.normalize().scale(alignWeight);

    influence.add(noise).add(avoid).add(center).add(align);
    influence.add(mouse.normalize().scale(mouseWeight));

    influence.add(obstacleInfluence.normalize().scale(obstacleWeight));

    if (location.x < outsideAvoidanceZone) influence.add(new Vector(100,0));
    if (location.y < outsideAvoidanceZone) influence.add(new Vector(0,100));
    if (location.x > width - outsideAvoidanceZone) influence.add(new Vector(-100,0));
    if (location.y > height - outsideAvoidanceZone) influence.add(new Vector(0,-100));

    influence.add(velocity.copy().normalize().scale(oldWeight));     
    influence.normalize().scale(speed * (1 - oldWeight));
  }

  void applyInfluences() {
    calculateInfluence();


    if (!boidswalk) {
      velocity.normalize().scale(speed);
    } 
    else  {
      velocity.scale(oldWeight);
    }

    velocity.add(influence);
  }

  void resetInfluences() {
    influence = new Vector(0,0);
    highlight = false;

    avoid = new Vector();
    center = new Vector();
    align = new Vector();
    mouse = new Vector();
  }
}









