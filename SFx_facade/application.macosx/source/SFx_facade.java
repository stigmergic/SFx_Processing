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

public void setup() {
  float aspect = 2.6666666666666665f;
  //float aspect = 1440.0/900.0;
  int w = (int) (screen.width * 1);
  size(w, PApplet.parseInt(w/aspect));
  
  setupFonts();  
    
  textFont(randomFont(), textHeight);
  
  randomWords();
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

  textSize(24);
  fill(255);
  text("X: " + PApplet.parseFloat(mouseX)/width + ", Y: " + PApplet.parseFloat(mouseY)/height, 0,height);  
  String s = MASKMODES[maskmode];
  float w = textWidth(s);
  text(s,width-w, height);
  ticks += 1;
  drawBanner(); 
}

  public float getX(float x) {
    return x*width;  
  }
  
  public float getY(float y) {
    return y*height;
  }






PFont ocr = createFont("OCRAStd", 12);
String bannerString = "     \"Mapping The Complex\"    June 17-19     \"Mapping The Complex\"";
float bannerWidth = 100;

public void drawBanner() {
  bannerWidth = getX(0.385f);
  textFont(ocr, 10);
  String s2 = bannerString + bannerString;
  int i = (int) (ticks/8 % (bannerString.length()));
  int j = s2.length();
  
  String s = s2.substring(i,j);
  float w = textWidth(s);
  
  while (w>bannerWidth) {
    j --;
    s = s2.substring(i,j);
    w = textWidth(s);
  }
  
  text(s, getX(0.3134f), getY(0.47f));
}


 public int randomColor() {
   colorMode(HSB);
   return color(random(255),255,255);
 }

  public int randomColor(int avoid) {
    colorMode(HSB);
    float h = hue(avoid);
    int c = randomColor();
    while (abs(hue(c) - h)<30) {
      c = randomColor();
    }
    
    return c;
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
  //Entrance e = entrances.get(int(random(entrances.size())));
  Entrance e = entrances.get(3);
  
  for (Letter l : letters) {
    e.position(l);
  }  
}

// -------------------------------------------------

class Entrance {
  
  public void position(Letter l) {
    l.x = getX(0.5f);
    l.y = getY(0.25f);
    float f = random(2*PI);
    l.dx = cos(f);
    l.dy = sin(f); 
    l.curVel = 5; 
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
    float f = random(PI/2);
    if  (random(1)<0.5f) {
      l.x = getX(0.0208f);
      f = -f;
      l.dx = cos(f);
      l.dy = sin(f);
      
    } else {
      l.x = getX(0.9835f);
      l.dx = cos(f + PI);
      l.dy = cos(f + PI);
      
    }
    l.y = getY(0.2660f);  
    l.curVel = 5;
    l.ndx = 0;
    l.ndy = 0;
    l.nn = 0;
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
float friction = 1.0f;
float backAlpha = 100;
int  backColor = color(0);

public static final String[] MASKMODES = {
  "Rectangle",
  "Triangle"
};

public static final int FIRST_MASKMODE = 0;
public static final int LAST_MASKMODE = MASKMODES.length-1;
int maskmode = FIRST_MASKMODE;


public void keyPressed() {
  switch(key) {
    case 'b':
      drawbackground = !drawbackground;
      break;

    case 'v':
      backColor = color(0);
      break;

   case 'V':
      for (Letter l : letters) {
        l.co = color(255);  
      }
      break;

    case 'C':
      backColor = randomColor();
      for (Letter l : letters) {
        l.co = randomColor(backColor);  
      }
      break;

     case 'c':
      for (Letter l : letters) {
        l.co = randomColor(backColor);  
      }
      break;

    case 'w':
      randomWords();
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
    case 'n':
      drawfilter = !drawfilter;
      break;
    case 'd':
      if (mousePoints.hasPoints()) {
        mousePoints.pop();
      } else {
        int i = masks.size()-1;
        if (i>=0) {
          Mask m = masks.get(i);
          mousePoints.add(m.getPoints());
          mousePoints.pop();
          masks.remove(i);
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
    case 'M':
      maskmode += 1;
      if (maskmode > LAST_MASKMODE) maskmode = FIRST_MASKMODE;
      break;
    
    default:
      println("Key Pressed: " + key);
  }  
}

/*
String[] words = {
      "Its not true that I had nothing on, I had the radio on.",
      "sfX"
    };

*/

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

public void randomWords() {
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
 
}

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
  float accel = 0.01f;
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
    fontSize = textHeight;
  }

  public void draw() {
    stroke(255);
    noFill();
    if (drawdebug) rect(x,y,w,-h);

    pushMatrix();
    translate(x+w/2,y-h/2);
    rotate(a);

    //fill(0,0,50);
    //text(letter, maxSpeed, maxSpeed); 
    textSize(fontSize);    
    fill(co);
    text(letter, -w/2, h/2);

    noFill();
    stroke(100,255,255);
    if (drawdebug) rect(-w/2,-h/2,w,h);

    popMatrix();
  } 

  public void step() {
    if (nn>0) {
      ndx /= nn; 
      ndy /= nn; 
      float l = sqrt(ndx*ndx + ndy*ndy);
      if (l>0) {
      dx = ndx/l*friction;
      dy = ndy/l*friction;
      } else {
        dx = 0;
        dy = 0;  
      }
      
      nn = 1;
      ndx = dx;
      ndy = dy;
    }
    
    fontSize = textHeight  * (sin((-ticks+offset)/30.0f) + 1.5f) * 0.75f;
    textSize(fontSize);
    w = textWidth(letter);
    h = fontSize;
    
    move();
  }

  public void move() {
    if (resolve) {
      float nx = 0;
      float ny = 0; 
      float na = 0;

      if (preceeding != null) {
        nx += preceeding.x + preceeding.w;
        ny += preceeding.y;
        na += preceeding.a;
      } 
      else {
        ny += 170;
        nx += 0; //470;
        na += 0;
      }
      if (next != null) {
        nx += next.x - w;
        ny += next.y;
        na += next.a;
      } 
      else {
        ny += 170;
        nx += width-w; //1020-w;
        na += 0;
      }

      nx /= 2;
      ny /= 2;
      na /= 2;
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
      ndx -= dx*2;
      nn += 1;
    } 
    if (x<0) {
      x = 0;
      ndx -= dx*2;
      nn += 1;
    } 
    if (y>height) {
      y = height;
      ndy -= dy*2;
      nn += 1;
    } 
    if (y<h) {
      y = h;
      ndy -= dy*2;
      nn += 1;
    }
  }
}

PointBuffer mousePoints;

ArrayList<Mask> masks;

public void setupMasks() {
  masks = new ArrayList<Mask>();
  mousePoints = new PointBuffer();
}

public boolean isMouseMode(String s) {
  return MASKMODES[maskmode].equals(s);
}
  

public void drawMasks() {
  for (Mask m : masks) {
    m.draw();
  }

  if (domouse && mousePoints.hasPoints()) {
    noFill();
    stroke(255);
    mousePoints.draw(mouseX, mouseY);
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
  mousePoints.push(new PVector(mouseX, mouseY));
  
  if (isMouseMode("Rectangle") && mousePoints.size() == 2) { 
    masks.add(new RectMask(mousePoints));
  } else if (isMouseMode("Triangle") && mousePoints.size() == 3) {
    masks.add(new TriangleMask(mousePoints));  
  }
}

// -------------------------------------

abstract class Mask {
    int repelCount = 0;
    
    public void repel(Letter l) {
      
    };
    
    public void incCount() {
      repelCount += 1;  
    }
    
    public void clearCount() {
      repelCount = 0;  
    }
    
    public int repelCount() {
      return repelCount;
    }
    
    public void draw() {
      
    };
    public PVector[] getPoints() {
      return null;  
    };
}


class RectMask extends Mask {
  float x,y,w,h;

  public RectMask(PointBuffer pts) {
    PVector np1 = pts.pop();
    PVector np2 = pts.pop();
    x = min(np1.x, np2.x);
    y = min(np1.y, np2.y);
    w = abs(np1.x - np2.x);
    h = abs(np1.y - np2.y);
  }

  public void draw() {
    fill(repelCount()>0 ? 50 : 0);
    stroke(255);
    rect(x,y,w,h);
    
    clearCount();  
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
    
    incCount();
  } 
 
  public PVector[] getPoints() {
    PVector[] pts = new PVector[2];
    pts[0] = new PVector(x,y);
    pts[1] = new PVector(x+w,y+h);
    
    return pts;
  } 
  
}

class TriangleMask extends Mask {
  PVector[] points;

  public TriangleMask(PointBuffer pts) {
    points = new PVector[3];
    points[0] = pts.pop();
    points[1] = pts.pop();
    points[2] = pts.pop();
  }

  public void draw() {
    fill(repelCount()>0 ? 50 : 0);
    stroke(255);
    beginShape();
    vertex(points[0].x, points[0].y);
    vertex(points[1].x, points[1].y);
    vertex(points[2].x, points[2].y);
    endShape(CLOSE);
    
    clearCount();  
  }

  public void repel(Letter l) {
    if (!inside(new PVector(l.x + l.w/2, l.y - l.h/2))
        && !inside(new PVector(l.x , l.y - l.h)) 
        && !inside(new PVector(l.x + l.w, l.y - l.h)) 
        && !inside(new PVector(l.x + l.w, l.y)) 
        && !inside(new PVector(l.x, l.y))
    ) return;
   
    float cx = (points[0].x + points[1].x + points[2].x) / 3;
    float cy = (points[0].y + points[1].y + points[2].y) / 3;
    float lx = l.x + l.w/2;
    float ly = l.y - l.h/2;
    
    float f = atan2(ly-cy,lx-cx);
    l.ndx += cos(f);
    l.ndy += sin(f);
    l.nn += 1;

    incCount(); 
  } 
 
  public PVector[] getPoints() {    
    return points;
  } 
  
  public boolean inside(PVector p) {
    //Adapted from: http://www.blackpawn.com/texts/pointinpoly/default.html
    // Compute vectors        
    PVector v0 = PVector.sub(points[2], points[0]);
    PVector v1 = PVector.sub(points[1], points[0]);
    PVector v2 = PVector.sub(p, points[0]);

    // Compute dot products
    float dot00 = PVector.dot(v0, v0);
    float dot01 = PVector.dot(v0, v1);
    float dot02 = PVector.dot(v0, v2);
    float dot11 = PVector.dot(v1, v1);
    float dot12 = PVector.dot(v1, v2);

    // Compute barycentric coordinates
    float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

    // Check if point is in triangle
    return (u > 0) && (v > 0) && (u + v < 1); 
  }
  
}




public void mousePressed() {
  masksMousePressed();  
}


class PointBuffer {
  ArrayList<PVector> points;

  public PointBuffer() {
    points = new ArrayList<PVector>();
  }
  
  public int size() {
    return points.size();  
  }

  public void push(PVector p) {
    points.add(p);
  }

  public PVector pop() {
    if (!hasPoints()) return null;

    int i = points.size()-1;

    PVector p = points.get(i);
    points.remove(i);
    return p;
  }
  
  public PVector popHead() {
     if (!hasPoints()) return null;
   
    PVector p = points.get(0);
    points.remove(0);
    return p;    
  }
  
  public void add(PVector[] pts) {
    for (PVector p : pts) push(p);  
  }
  
  public boolean hasPoints() {
    return points.size()>0;  
  }
  
  public void draw() {
    noFill();
    stroke(255);
    beginShape();
    for (PVector p : points) vertex(p.x, p.y);
    endShape(CLOSE);  
  }
  
  public void draw(float x, float y) {
    push(new PVector(x,y));
    draw();
    pop();  
  }
}




//close the class
}
