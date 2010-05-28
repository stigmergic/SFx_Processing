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
  float accel = 0.1;
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
    h = textHeight;
  }

  void draw() {
    stroke(255);
    noFill();
    if (drawdebug) rect(x,y,w,-h);

    pushMatrix();
    translate(x+w/2,y-h/2);
    rotate(a);
    scale((sin((-ticks+offset)/30.0) + 1.5) * 0.75);

    //fill(0,0,50);
    //text(letter, maxSpeed, maxSpeed);      
    fill(co);
    text(letter, -w/2, h/2);

    popMatrix();
  } 

  void step() {
    if (nn>0) {
      dx = ndx / nn;
      dy = ndy / nn;
      nn = 0;
      ndx = 0;
      ndy = 0;
    }
    
    move();
  }

  void move() {
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

