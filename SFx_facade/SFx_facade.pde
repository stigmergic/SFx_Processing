

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

void setup() {
  float aspect = 2.6666666666666665;
  //float aspect = 1440.0/900.0;
  int w = (int) (screen.width * 1);
  size(w, int(w/aspect));
  
  setupFonts();  
    
  textFont(randomFont(), textHeight);
  
  randomWords();
  setupEntrances();
  entrance();
  
  setupMasks();
  
  img = loadImage("Facade3.jpg");
}

void draw() {
  if (drawbackground) background(0);
  if (drawimage) drawImage(img);
  if (drawfilter) {
    noStroke();
    fill(backColor,backAlpha);
    rect(0,0,width,height);
  }
  
  for (Letter l : letters) {
    l.step();
    l.draw();
  }

  if (drawmasks) drawMasks();
  repelMasks();

  textSize(24);
  fill(255);
  text("X: " + float(mouseX)/width + ", Y: " + float(mouseY)/height, 0,height);  
  String s = MASKMODES[maskmode];
  float w = textWidth(s);
  text(s,width-w, height);
  ticks += 1;
  drawBanner(); 
}

  float getX(float x) {
    return x*width;  
  }
  
  float getY(float y) {
    return y*height;
  }





