import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 




/*
   Saturated Colors
  
  Letters are colored randomly
    -- Color Pallate
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

public void setup() {
  float aspect = 2.6666666666666665f;
  size(screen.width, PApplet.parseInt(screen.width/aspect));
  
  setupFonts();  
    
  textFont(randomFont(), textHeight);
  
  phrase = words[0];
  
  Letter l, ol = null;
  int i =0;
  letters = new ArrayList<Letter>();
  for (char c : phrase.toCharArray()) {
    l = new Letter(c);
    l.offset = i * 10;
    if (ol != null) {
      l.preceeding = ol;
      ol.next = l;  
      
    }
    ol = l;
    letters.add(l);
    i+=1;
  }

  setupEntrances();
  entrance();
  
  setupMasks();
  
  img = loadImage("Facade3.jpg");
}

public void draw() {
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

  fill(255);
  text("X: " + mouseX + ", Y: " + mouseY, 0,height);  
 
  ticks += 1;
}






 public int randomColor() {
   colorMode(HSB);
   return color(random(255),255,255);
 }


float top;
float bottom;

ArrayList<Entrance> entrances;

public void setupEntrances() { 
  top = 70;
  bottom = 460;
 
  entrances = new ArrayList<Entrance>();
  
  entrances.add(new Entrance());
  entrances.add(new EntranceBottom());
  entrances.add(new EntranceTop());
  entrances.add(new EntranceSides());
}

public void entrance() {
  Entrance e = entrances.get(PApplet.parseInt(random(entrances.size())));
  for (Letter l : letters) {
    e.position(l);
  }  
}

// -------------------------------------------------

class Entrance {
  public void position(Letter l) {
    l.x = width/2;
    l.y = height/2;  
  }  
}

class EntranceBottom extends Entrance{
  public void position(Letter l) {
    l.x = random(width);
    l.y = bottom;
    l.dx = 0;
    l.dy = -1;  
  }   
}

class EntranceTop extends Entrance{
  public void position(Letter l) {
    l.x = random(width);
    l.y = top;  
  }   
}

class EntranceSides extends Entrance{
  public void position(Letter l) {
    l.x = (random(1)<0.5f) ? 0 : width;
    l.y = top;  
  }   
}



int textHeight = 36;
ArrayList<PFont> fonts;

public void setupFonts() {
   fonts = new ArrayList<PFont>();
  
  fonts.add(createFont("STXihei", textHeight));
  fonts.add(createFont("AmericanTypewriter-CondensedLight", textHeight));
  fonts.add(createFont("HelveticaNeue-UltraLightItalic", textHeight));
  fonts.add(createFont("EuphemiaUCAS", textHeight));
  fonts.add(createFont("DecoTypeNaskh", textHeight));
  fonts.add(createFont("Cracked", textHeight));
  fonts.add(createFont("Georgia-BoldItalic", textHeight));
  fonts.add(createFont("GiddyupStd", textHeight));
  fonts.add(createFont("OCRAStd", textHeight));
 
}

public PFont randomFont() {
 return fonts.get(PApplet.parseInt(random(fonts.size()))); 
}



PImage img;
float imgOffX;
float imgOffY;
float imgWidth;
float imgHeight;
float imgScale;


public void drawImage(PImage img) {
    imgScale = min(PApplet.parseFloat(width)/img.width, PApplet.parseFloat(height)/img.height);
    imgWidth = img.width*imgScale;
    imgHeight = img.height*imgScale;
    imgOffX = (width - imgWidth)/2;
    imgOffY = (height - imgHeight)/2;
    
    image(img,imgOffX,imgOffY,imgWidth,imgHeight);
}

boolean resolve = false;
boolean drawimage = true;
boolean drawmasks = true;
boolean drawdebug = false;
boolean drawfilter = true;
boolean drawbackground = true;
boolean domouse = true;

float maxSpeed = 5.0f;
float backAlpha = 100;
int  backColor = color(0);

public void keyPressed() {
  switch(key) {
    case 'b':
      drawbackground = !drawbackground;
      break;
    case 'c':
      backColor = randomColor();
      break;
    case 'm':
      drawmasks = !drawmasks;
      break;
    case 's':
      drawdebug = !drawdebug;
      break;
    case 'f':
        textFont(randomFont(), textHeight);
        break;
    case 'v':
      drawfilter = !drawfilter;
      break;
    case 'd':
      if (lastX>=0) {
        lastX = -1;
      } else {
        if (masks.size()>0) {
          Mask m = masks.get(masks.size()-1);
          lastX = m.x;
          lastY = m.y;
          masks.remove(m);
        }
      }
      
      break;
    case 'r':
      resolve = !resolve;
      break;
    case 'e':
      entrance();
      break;
    case 'i':
      drawimage = !drawimage;
      break;
    case ']':
      maxSpeed *= 1.01f;
      println("Maxspeed: " + maxSpeed);
      break;
    case '[':
      maxSpeed *= 0.99f;
      println("Maxspeed: " + maxSpeed);
      break;
    case ',':
      backAlpha = max(0, backAlpha-1);
      break;
    case '.':
      backAlpha = min(255, backAlpha+1);
      break;
      
    default:
      println("Key Pressed: " + key);
  }  
}
String[] words = {
      "The Santa Fe Complex",
      "Santa Fe Complex", 
      "sf_x",
      "the Complex",
      "sfX"
    };

String phrase;
ArrayList<Letter> letters;

float letterStrength = 10.0f;

public class Letter {

  String letter;
  float x,y;
  int offset = 0;
  float ox,oy;
  float dx,dy;
  
  float ndx, ndy, nn;
  
  float fontSize;
  float w,h;
  int co;
  float a, da;
  float accel = 0.1f;
  float curVel = maxSpeed;

  Letter next = null;
  Letter preceeding = null;

  public Letter(char c) {
    letter = "" + c; 
    x = width/2;
    y = height/2;
    float f = random(PI*2);
    dx = cos(f);
    dy = sin(f);
    da = random(0.1f);

    co = randomColor();

    w = textWidth(letter);
    h = textHeight;
  }

  public void draw() {
    stroke(255);
    noFill();
    if (drawdebug) rect(x,y,w,-h);

    pushMatrix();
    translate(x+w/2,y-h/2);
    rotate(a);
    scale((sin((-ticks+offset)/30.0f) + 1.5f) * 0.75f);

    //fill(0,0,50);
    //text(letter, maxSpeed, maxSpeed);      
    fill(co);
    text(letter, -w/2, h/2);

    popMatrix();
  } 

  public void step() {
    if (nn>0) {
      dx = ndx / nn;
      dy = ndy / nn;
      nn = 0;
      ndx = 0;
      ndy = 0;
    }
    
    move();
  }

  public void move() {
    if (resolve) {
      float nx = x;
      float ny = y; 
      float na = a;

      if (preceeding != null) {
        nx += preceeding.x + preceeding.w;
        ny += preceeding.y;
        na += preceeding.a;
      } 
      else {
        ny += 170;
        nx += 470;
        na += 0;
      }
      if (next != null) {
        nx += next.x - w;
        ny += next.y;
        na += next.a;
      } 
      else {
        ny += 170;
        nx += 1020-w;
        na += 0;
      }

      nx /= 3;
      ny /= 3;
      na /= 3;
      a = na;

      if (dist(nx,ny,x,y)>curVel) {
        float d = atan2(ny-y, nx-x);     
        ndx += cos(d) * letterStrength;
        ndy += sin(d) * letterStrength;
        nn += 1;
      } 
      else {
        curVel = 0;
      }
    } 
    else {
      a += da;
    }

    x += dx*curVel;
    y += dy*curVel;

    curVel = min(maxSpeed, curVel + accel);

    if (x+w>width) {
      x = width-w;
      ndx -= dx;
      nn += 1;
    } 
    if (x<0) {
      x = 0;
      ndx -= dx;
      nn += 1;
    } 
    if (y>height) {
      y = height;
      ndy -= dy;
      nn += 1;
    } 
    if (y<h) {
      y = h;
      ndy -= dy;
      nn += 1;
    }
  }
}

float lastX = -1, lastY;


ArrayList<Mask> masks;

public void setupMasks() {
  masks = new ArrayList<Mask>();
  
  //masks.add(new Mask());  
}

public void drawMasks() {
  for (Mask m : masks) {
    m.draw();
  }

  if (domouse && lastX >= 0) {
    noFill();
    stroke(255);
    rect(lastX, lastY, mouseX - lastX, mouseY - lastY);  
  }  
}

public void repelMasks() {
  for (Mask m : masks) {
    for (Letter l : letters) {
      m.repel(l);
    }
  }    
}


public void masksMousePressed() {
  if (!domouse) return;
  
  if (lastX >= 0) {
    float x = min(lastX, mouseX);
    float y = min(lastY, mouseY);
    float w = abs(lastX-mouseX);
    float h = abs(lastY-mouseY);
    
    masks.add(new Mask(x,y,w,h)); 
    lastX = -1;
  } else {
    lastX = mouseX;
    lastY = mouseY;
  }  
}

// -------------------------------------

class Mask {
  float x, y, w, h;

  public Mask(float _x, float _y, float _w, float _h) {
   x = _x;
   y = _y;
   w = _w;
   h = _h; 
    
  }

  public void draw() {
    fill(0);
    stroke(255);
    rect(x,y,w,h);  
  }

  public void repel(Letter l) {
    if ((l.x + l.w < x 
        || (l.y-l.h)>y + h 
        || (l.x ) > (x + w)
        || (l.y) < (y ))) return;
        
    float cx = x + w/2;
    float cy = y + h/2;
    float lx = l.x + l.w/2;
    float ly = l.y - l.h/2;
    
    float f = atan2(ly-cy,lx-cx);
    l.ndx += cos(f);
    l.ndy += sin(f);
    l.nn += 1;
    
  }  
  
}


public void mousePressed() {
  masksMousePressed();  
}



//close the class
}
