ArrayList trails = new ArrayList();
int bubbleAlpha = 120;
int maxbubbles = 1000;

class Location {
  float x,y,z;
  float r,g,b;
  float life;  
  float dirY, dirX;
  float radius;

  public Location(float _x, float _y) {
    x = _x;
    y = _y;  
  }
  public Location() {
  }

  void addLocation(Location l) {
    x += l.x;
    y += l.y;
    z += l.z;
    r += l.r;
    g += l.g;
    b += l.b;
    life += l.life;
    dirY += l.dirY;
    dirX += l.dirX;
    radius += l.radius;  
  }

  void scale(float f) {
    x *= f;
    y *= f;
    z *= f;
    r *= f;
    g *= f;
    b *= f;
    life  *= f;
    dirY  *= f;
    dirX  *= f;
    radius  *= f;    
  }
} 

color getBubbleColor(Location bubble) {
  if (drawgrayscale) {
    float c = max(bubble.r, bubble.g, bubble.b);
    return color(c,c,c,bubbleAlpha);
  } 
  return color(bubble.r,bubble.g,bubble.b,bubbleAlpha);  
}

void drawBrains(Location tloc, Location oloc) {
  float beg,end;
  beg = atan2(tloc.dirY*height,tloc.dirX*width);
  end = beg+PI/2;
  beg = beg-PI/2;
  arc(tloc.x*width,tloc.y*height,tloc.radius*.5,tloc.radius*.5,beg,end);

  if (oloc != null) {
    beg = atan2((tloc.y-oloc.y)*height,(tloc.x-oloc.x)*width) + PI;
    end = beg+PI/8;
    beg = beg-PI/8;
    arc(tloc.x*width,tloc.y*height,tloc.radius*.9,tloc.radius*.9,beg,end);
  }  
}

void drawBubble(Location tloc) {
  fill(getBubbleColor(tloc));
  noStroke();
  ellipse(tloc.x*width,tloc.y*height,tloc.radius,tloc.radius);


}

void drawBubbleLine(Location tloc, Location oloc) {
  stroke(100,100,0);
  strokeWeight(1);
  line(tloc.x*width,tloc.y*height,oloc.x*width,oloc.y*height);

}

void bubblestep() {
  Location tloc = null;
  Location oloc = null;
  Location rloc; 
  ArrayList removals = new ArrayList();
  print("trails: " + trails.size());
  int lifetot = 0;
  for (int i=0; i<trails.size(); i++) {
    //if (i==0) oloc = (Location) trails.get(trails.size()-1);
    tloc= (Location) trails.get(i);
    tloc.life -= 1;
    tloc.z *= 0.999;
    lifetot += tloc.life;

    tloc.radius = (50*sqrt(tloc.z)) + 10.0 * tloc.life/1000;

    drawBubble(tloc);

    if (drawBrains) drawBrains(tloc,oloc);
    if (drawLines && oloc != null) drawBubbleLine(tloc,oloc);

    if (oloc != null && layout) {
      float d2 = dist(tloc.x,tloc.y,oloc.x,oloc.y);
      float d3 = dist(tloc.dirX,tloc.dirY,0,0);
      float force = d3*1/100.0*(tloc.radius+1);
      force = force < d2 ? force : d2;
      tloc.x = tloc.x + ((oloc.x - tloc.x)/d2)*force;
      tloc.y = tloc.y + ((oloc.y - tloc.y)/d2)*force;
      //oloc.x = oloc.x - ((oloc.x - tloc.x)/d2)*force;
      //oloc.y = oloc.y - ((oloc.y - tloc.y)/d2)*force;

    }
    oloc = tloc;
    if (layout) bounce(tloc);

    if (tloc.radius/height>0.25) {
      burst(tloc,100);
      tloc.life = -1;
    }

    for (int j=0; j<5; j++) {
      if (layout && tloc.life>0) find_overlap(tloc);
    }

  }
  print (" lifetot: " + lifetot);
  grim_reaper();

}

void grim_reaper() {
  Location tloc;        
  for (int i =0; i<trails.size(); i++) {
    tloc = (Location) trails.get(i);
    if (tloc.life<=0) trails.remove(i);
  }

  while (trails.size()>maxbubbles) {
    trails.remove(0);
  }  

}

int sign(float i) {
  return i>=0?1:-1;
}

void find_overlap(Location tloc) {
  int randTrail;
  float reach = 0.020;
  Location rloc;
  float d;
  randTrail = int(random(trails.size()));
  rloc = (Location) trails.get(randTrail);

  if (rloc != tloc && tloc.life > 0) {
    if (rloc.life > 0) {
      d = dist(rloc.x,rloc.y,tloc.x,tloc.y);
      if (d<tloc.radius/width/2+tloc.radius/width/4) {
        if (rloc.z < tloc.z) {
          joinbubbles(tloc,rloc);
        } 
        else {
          joinbubbles(rloc,tloc);
        }
      }

    }
  } 
}

void bounce(Location tloc) {

  tloc.y += tloc.dirY;
  tloc.x += tloc.dirX;

  if (tloc.y+tloc.radius/height/2>1.0) {
    tloc.y = 1.0-tloc.radius/height/2;
    tloc.dirY = -1 * sign(tloc.dirY) * min (0.125, abs(tloc.dirY*1.1));
    tloc.g +=10;
  }
  if (tloc.y-tloc.radius/height/2<0.0) {
    tloc.y = tloc.radius/height/2;
    tloc.dirY = -1 * sign(tloc.dirY) * min (0.125, abs(tloc.dirY*1.1));
    tloc.g +=10;

  }
  if (tloc.x+tloc.radius/width/2>1.0) {
    tloc.x = 1.0-tloc.radius/width/2;
    tloc.dirX = -1 * sign(tloc.dirX) * min (00.125, abs(tloc.dirX*1.1));
    tloc.b +=10;

  }
  if (tloc.x-tloc.radius/width/2<0.0) {
    tloc.x = tloc.radius/width/2;
    tloc.dirX = -1 * sign(tloc.dirX) * min (0.125, abs(tloc.dirX*1.1));
    tloc.b +=10;

  }

}

void spawn(MyBlob b, color c) {
  Location nloc = new Location();
  DoubleMatrix2D point = getPoint( b.centerX() * width,  b.centerY() * height);         
  point = getCamToProj(point);
  nloc.life = 400;
  nloc.x = (float)point.get(0,0)/width + nloc.dirY;
  nloc.x = max(0,min(1,nloc.x));
  nloc.y = (float)point.get(1,0)/height + nloc.dirX;
  nloc.y = max(0,min(1,nloc.y));
  nloc.z = b.width()*b.height()*100;

    float dir =  random(2*PI);
  float mag = random(1)/100+0.01;

  if (trails.size()>0) {
    Location tloc = (Location) trails.get(0);
      dir = atan2(-(nloc.y-tloc.y),-(nloc.x-tloc.x));
      mag = 0.01*dist(nloc.x,nloc.y,tloc.x,tloc.y);
  } else {
  }
  nloc.dirY = sin(dir)*width/height*mag;
  nloc.dirX = cos(dir)*mag;
  nloc.r = red(c);
  nloc.g = green(c);
  nloc.b = blue(c);
  trails.add(nloc);

}

void spawnBubbles(ArrayList blobList, color c) {
  MyBlob b;
  for (int i=0; i<blobList.size(); i++) {
    b = (MyBlob) blobList.get(i);    
    spawn(b,c);
  }  

}

void burst(Location tloc, int num) {
  for (int j=0; j<num; j++) {
    Location nloc = new Location();          
    nloc.z = tloc.z/num;
    nloc.life = tloc.life/num + random(50);
    float dir = j/float(num)*2*PI; //random(2*PI);
    nloc.dirY = random(0.01)*sin(dir)*width/height;
    nloc.dirX = random(0.01)*cos(dir);
    nloc.x = tloc.x+nloc.dirX*10;
    nloc.y = tloc.y+nloc.dirY*10; 
    nloc.r = tloc.r/num;
    nloc.g = tloc.g/num;
    nloc.b = tloc.b/num;         
    trails.add(nloc);
  }
  burst_sound(tloc.x);

}

void joinbubbles(Location b1, Location b2) {
  b1.x = (b1.x+b2.x)/2;
  b1.y = (b1.y+b2.y)/2;
  b1.z += b2.z;
  b1.life += b2.life;
  b1.r += b2.r;
  b1.g += b2.g;
  b1.b += b2.b;
  b2.life = -1;  
  pop_sound(b1.x,min(sqrt(b1.z*10)/6, 0.95));

}
