float lastX = -1, lastY;


ArrayList<Mask> masks;

void setupMasks() {
  masks = new ArrayList<Mask>();
  
  //masks.add(new Mask());  
}

void drawMasks() {
  for (Mask m : masks) {
    m.draw();
  }

  if (domouse && lastX >= 0) {
    noFill();
    stroke(255);
    rect(lastX, lastY, mouseX - lastX, mouseY - lastY);  
  }  
}

void repelMasks() {
  for (Mask m : masks) {
    for (Letter l : letters) {
      m.repel(l);
    }
  }    
}


void masksMousePressed() {
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

  void draw() {
    fill(0);
    stroke(255);
    rect(x,y,w,h);  
  }

  void repel(Letter l) {
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

