
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

float letterStrength = 10.0;

void randomWords() {
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
  
  /*
  for (int j=0; j<50; j++) {
    letters.add(new TriangleShapes(' '));  
  }
  */
 
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
  color co;
  float a, da;
  float accel = 0.01;
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
    
    da = random(0.1);

    co = randomColor();

    w = textWidth(letter);
    h = fonts.textHeight;
    fontSize = fonts.textHeight;
  }

  void drawDrop() {
    if (letter.equals(" ")) return;
    pushMatrix();
    textSize(fontSize * 1.125); 
    translate(x+w/2+ cos(ticks/10.0) * fontSize/4* 1.125,y-h/2+ sin(ticks/100.0) * fontSize/4* 1.125);
    rotate(a);

    if (fonts.letterFont.isDropShadow()) {
      fill(dropColor);
      text(letter, -w/2 , h/2 );  
    }
       
    popMatrix();
  }

  void draw() {
    if (letter.equals(" ")) return;

    if ((resolution & BLINKING_RESOLUTION) == BLINKING_RESOLUTION) {
      if (random(1)<0.5) return;  
    }

    
    stroke(255);
    noFill();
    if (fonts.letterFont.isDrawBox()) rect(x,y,w,-h);

    pushMatrix();
    translate(x+w/2,y-h/2);
    rotate(a);

    //noFill();
    fill(0);
    stroke(100,255,255);
    if (fonts.letterFont.isDrawBox()) rect(-w/2,-h/2,w,h);
    if (fonts.letterFont.isCircles()) ellipse(0,0,w,h);

    //fill(0,0,50);
    //text(letter, maxSpeed, maxSpeed); 
    textSize(fontSize); 
       
    fill(co);
    text(letter, -w/2, h/2);

    popMatrix();
    
    for (Letter l : letters) {
      if (l.equals(this)) continue;
      l.repel(this);  
    }   
  } 

  void step() {
    
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
    
    if ((resolution & WAVE_RESOLUTION) == WAVE_RESOLUTION) {
      fontSize = fonts.textHeight  * (sin((-ticks+offset)/30.0) + 1.5) * 1.55;
    } else {
      fontSize = fonts.textHeight;  
    }
    
    if ((resolution & SHAKY_RESOLUTION) == SHAKY_RESOLUTION) {
      x += random(10)-5;
      y += random(10)-5;
    }
    if ((resolution & ROTAIONAL_RESOLUTION) == ROTAIONAL_RESOLUTION) {
      a += 0.1;
    }
    
    textSize(fontSize);
    w = textWidth(letter);
    if (letter.equals(" ")) w *= 3;
    h = fontSize;
    
    move();
  }
  
  void repel(Letter l) {
    if ((l.x + l.w < x 
        || (l.y-l.h)>y + h 
        || (l.x ) > (x + w)
        || (l.y) < (y ))) return;
        
    float cx = x + w/2;
    float cy = y - h/2;
    float lx = l.x + l.w/2;
    float ly = l.y - l.h/2;
    
    float f = atan2(ly-cy,lx-cx);
    l.ndx += cos(f) *10;
    l.ndy += sin(f) *10;
    l.nn += 1;
    
  } 


  void move() {
    if (is("resolve")) {
      float nx = 0;
      float ny = 0; 
      float na = 0;

      if (preceeding != null) {
        nx += preceeding.x + preceeding.w;
        ny += preceeding.y;
        na += preceeding.a;
      } 
      else {
        ny += 150;
        nx += 0; //470;
        na += 0;
      }
      if (next != null) {
        nx += next.x - w;
        ny += next.y;
        na += next.a;
      } 
      else {
        ny += 150;
        nx += width-w; //1020-w;
        na += 0;
      }

      nx /= 2;
      ny /= 2;
      na /= 2;
      
      if ((resolution & ROTAIONAL_RESOLUTION) != ROTAIONAL_RESOLUTION) {
        a = na;
      }

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

public class TriangleShapes extends Letter {
  float offX1 = random(80) - 20;
  float offY1 = random(80) - 20;
  float offX2 = random(80) - 20;
  float offY2 = random(80) - 20;
  
  public TriangleShapes(char c) {
    super(c);
    
  }
  
  void draw() {
   fill(0);
   stroke(255);
   beginShape();
   vertex(x,y);
   vertex(x+offX1, y + offY2);
   vertex(x + offX2, y+offY2);
   endShape(CLOSE); 
  }
  
}

