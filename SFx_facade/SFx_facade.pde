import processing.opengl.*;

import net.stigmergic.flocking.FlockingState;


/*
   Saturated Colors
  
  Letters are colored randomly
    -- Color Palette
    -- Font -- bold/itali/normal (fixed for a set)
    -- Letters come in from somewhere
    -- Swarm around/bounce
    -- then go to resolved wording above
        -- words along path
        -- jiggle
        -- rotate?
    -- stamped words all over the building
        
    -- then fade/or fly away
    
    -- hand throwing letters in from side
    
    introducing letters, moving letters, resolution to words, fadeout
    
    
    intros:
      come in from sides
      hands tossing them in
      faces with letters coming from mouth
      
    
    movements:
      moving upward
      floating down like a bubble
      letters bounce off each other
    
    resolution:
      
    
    fadeout:
    
*/

public class SFx_facade extends PApplet {
long ticks = 0;
final String thisVersion = "SFx_facade v0.3";
String name = thisVersion;
//String lastName = 

FlockingState flock;

void setup() {
  //float aspect = 2.6666666666666665;
  //float aspect = 1440.0/900.0;
  float aspect = 2560/800.0;
  reset();
  
  
  //float aspect = 1280.0/800;
  int w = 2560;
  size(w, int(w/aspect));
  
  flock = new FlockingState(this);
  flock.setKioskmode(true);
  flock.setDrawbackground(false);
  flock.setShowmessage(false);
  
  fonts = new Fonts();  
  fonts.setFont();  
  
  
  randomWords();
  setupEntrances();
  randomEntrance();
  
  setupMasks();
  highlights = new Highlights();
  
  img = loadImage("Facade3.jpg");
  
  setupState();
  setupBanner();
  
  //twitterSetup();
  //readTwitter();
  
  loadState("last.yaml", this);  
}

void draw() {
  //randomBackground();
  
  if (is("drawbackground") && (!is("drawflock") || flock.isDrawbackground())) background(0);
  
  if (is("drawimage")) drawImage(img);
  if (is("drawfilter") && (flock.isDrawbackground() || !is("drawflock"))) {
    noStroke();
    if (is("drawimage")) {
      fill(backColor,100);
    } else {
      fill(backColor,backAlpha);      
    }
    rect(0,0,width,height);
  }
  
 if (!isFlockTime()) {

  fonts.setFont();
  for (Letter l : letters) {
    l.step();
    l.drawDrop();
  }
    }
    
  if (is("drawflock")) flock.draw();

  if (!isFlockTime()) {
  for (Letter l : letters) {
    l.draw();
  }
  }

  if (is("drawmasks")) drawMasks();
  repelMasks();


  if (is("drawdebug")) {
  textSize(24);
  fill(255);
  text("X: " + float(mouseX)/width + ", Y: " + float(mouseY)/height, 0,height); 
  text("BACKGROUND RGB: " + red(backColor) + ", " + green(backColor) + ", " + blue(backColor), 0, height - 40); 
  text("BACKGROUND HSB: " + hue(backColor) + ", " + saturation(backColor) + ", " + brightness(backColor), 0, height - 20); 
  
  text("FONT: " + fonts.letterFont.getName(), width/2, height-40);
  String s = MASKMODES[maskmode];
  float w = textWidth(s);
  text(s,width-w, height);
  }
  
  ticks += 1;
  
    if (!isFlockTime()) {

      drawBanner();
    }
    
  if (isHighlightMode() && mousePressed) {
    highlights.getCurrentHighLight().add(new PVector(mouseX, mouseY));
  } 
  
  
  if ((ticks % 100) == 0) {
    println("Elapsed time: " + elapsed() + " isBouncing: " + isBouncing() + " isResolving: " + isResolving() + " isStill: " + isStill()  + " isFlock: " + isFlockTime());  
  }
  
  if (isBouncing()) {
   states.set("resolve", false); 
  }
  if (isResolving() || isStill()) {
    states.set("resolve", true);  
  }
  if (isStill()) {
    resolution = 0;
    randomFontColor();
  }
  
  if (isFlockTime()) {
    randomFontColor();
    states.set("drawflock", true);  
  } else {
    states.set("drawflock", false);  
  }
  
  if (isFinished()) {
    reset();
    if (is("changingbackground")) {
      randomBackground();
    }
    
    fonts.randomFont();
    randomFontMovement();
    randomEntrance();
  }
  
  //text(name, width/2 - textWidth(name)/2, height/2 - textHeight/2);

  highlights.drawHighlights(); 

  if (states.is("mousecross")) {
    stroke(255);
    line(0,mouseY,width,mouseY);
    line(mouseX,0,mouseX,height);  
  }

}

  float getX(float x) {
    return x*width;  
  }
  
  float getY(float y) {
    return y*height;
  }


