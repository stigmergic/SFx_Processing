//import processing.opengl.*;
import fullscreen.*;

public class flocking_facade extends PApplet {
FullScreen fs1;

/**
 * Flocking -- 2009
 *   Based on a model for:
 *   New Mexico Super Computing Challenge 2008
 *   GUTS-XL
 * by Joshua Thorp
 *    joshua@stigmergic.net
 *
 */

long steps = 0;

int initialNumberOfBoids = 300;
Boids boids;

Obstacles obstacles;

String message = "";

color backgroundColor = color(0);

boolean kioskmode = false;

float boidSize = 5;
int minBoidSize = 3;
int maxBoidSize = 100;
int historyLength = 5;

float avoidanceRadius;
float neighborhoodRadius;

float outsideAvoidanceZone = 20;
int obstacleSize = 30;


float avoidanceRadiusInBoidSize = 3;
float neighborhoodRadiusInBoidSize = 15;

float mouseRadius = 50;

float noiseWeight = 1.0;
float saveAvoidanceWeight = 1000;//1000.0;
float saveCenterWeight = 10;//20.0;
float saveAlignWeight = 10.0;//80.0;
float avoidanceWeight = saveAvoidanceWeight;//1000.0;
float centerWeight = saveCenterWeight;//20.0;
float alignWeight = saveAlignWeight;//80.0;
float mouseWeight = 1000.0;
float obstacleWeight = 50000.0;

float oldWeight = 0.75;

float minSpeed = 4.5;
float maxSpeed = 5.51;

static float epsilon = 0.00001;


PFont font;
InfoPanel helpScreen;
boolean showhelppanel = false;

color getHighlightColor() {
  if (backgroundColor == color(0)) {
    return color(255);
  } 
  else {
    return color(0);
  }
}

void setup() {
  //OPENGL doesn't work with fullscreen library
  if (screen.width>200) 
    size(screen.width, screen.height);
  else
    size(1024,768);

  fs1 = new FullScreen(this);
  fs1.enter();

  boids = new Boids();
  updateNeighborhood();

  obstacles = new Obstacles();  
  font = loadFont("Chalkboard-48.vlw");
  textFont(font);

  helpScreen = new InfoPanel("help.pde");
  img = loadImage("Facade2.jpg");
}

void updateNeighborhood() {
  avoidanceRadius = boidSize * avoidanceRadiusInBoidSize;
  neighborhoodRadius = boidSize * neighborhoodRadiusInBoidSize;
}


void draw() {
  if (kioskmode && random(1000)<10) randomKey();

  if (showhelppanel) {
    helpScreen.showInfo();
    noLoop();
    return;
  } 

  if (drawbackground) {
    background(backgroundColor);
    drawImage(img);
    //draw non-discomfort zone
    fill(0);
    stroke(0);
    //rect(outsideAvoidanceZone-boidSize/2,outsideAvoidanceZone-boidSize/2,width-1-outsideAvoidanceZone*2+boidSize, height-1-outsideAvoidanceZone*2+boidSize);
  }

  if (avoidmouse) {
    //If boids are avoid mouse,  draw the avoidance mouse
    noFill();
    stroke(0,255,0);  
    ellipse(mouseX, mouseY, mouseRadius*2, mouseRadius*2);
    ellipse(mouseX, mouseY, mouseRadius/2, mouseRadius/2);
  }

  if (mousePressed) {
    //add a boid at the current mouse location
    if (dropobstacles) {
      obstacles.add(mouseX, mouseY);
    } 
    else {
      boids.addBoid(new Vector(mouseX, mouseY));
    }
  }

  obstacles.doSourceSink();

  while(boids.size()<initialNumberOfBoids) { 
    boids.addBoid();
  }
  initialNumberOfBoids = 0;

  if (boids.size()<initialNumberOfBoids || addboid) {
    //Add initial boids or add boids if the addboid is turned on
    boids.addBoid();
  }

  if (!pause) {
    //step the boids
    boids.step();
    steps ++;
  }

  boids.draw();
  obstacles.draw();

  if (steps % 100 == 0) {
    println("Steps: " + steps + " frameRate: " + frameRate);
  }  

  fill(getHighlightColor());
  text(message, width/2 - textWidth(message)/2, height - 50);
}

