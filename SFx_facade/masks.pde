PointBuffer mousePoints;

ArrayList<Mask> masks;

void setupMasks() {
  masks = new ArrayList<Mask>();
  mousePoints = new PointBuffer();
}

boolean isMouseMode(String s) {
  return MASKMODES[maskmode].equals(s);
}
  

void drawMasks() {
  for (Mask m : masks) {
    m.draw();
  }

  if (mousePoints.hasPoints()) {
    noFill();
    stroke(255);
    mousePoints.draw(mouseX, mouseY);
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
  
  mousePoints.push(new PVector(mouseX, mouseY));
  
  if (isMouseMode("Rectangle") && mousePoints.size() == 2) { 
    masks.add(new RectMask(mousePoints));
  } else if (isMouseMode("Triangle") && mousePoints.size() == 3) {
    masks.add(new TriangleMask(mousePoints));  
  }
}

   RectMask createRectMask(Map<String, Object> map) {
      RectMask mask = new RectMask();
      if (map.containsKey("x")) {
        mask.x = ((Double)map.get("x")).floatValue() * width;
      }  
      if (map.containsKey("y")) {
        mask.y = ((Double)map.get("y")).floatValue() * height;
      }  
      if (map.containsKey("h")) {
        mask.h = ((Double)map.get("h")).floatValue() * height;
      }  
      if (map.containsKey("w")) {
        mask.w = ((Double)map.get("w")).floatValue() * width;
      }  
      
      return mask;
    }

  TriangleMask createTriangleMask(Map<String, Object> map) {
    TriangleMask mask = new TriangleMask();

    if (map.containsKey("p0")) {
      float x = ((Double)((List)map.get("p0")).get(0)).floatValue() * width; 
      float y = ((Double)((List)map.get("p0")).get(1)).floatValue() * height;
      mask.points[0] = new PVector(x,y);
    } 
    if (map.containsKey("p1")) {
      float x = ((Double)((List)map.get("p1")).get(0)).floatValue() * width; 
      float y = ((Double)((List)map.get("p1")).get(1)).floatValue() * height;
      mask.points[1] = new PVector(x,y);
    } 
    if (map.containsKey("p2")) {
      float x = ((Double)((List)map.get("p2")).get(0)).floatValue() * width; 
      float y = ((Double)((List)map.get("p2")).get(1)).floatValue() * height;
      mask.points[2] = new PVector(x,y);
    } 
   
    return mask; 
  }


// -------------------------------------

abstract class Mask {
    int repelCount = 0;
    
    void repel(Letter l) {
      
    };
    
    void incCount() {
      repelCount += 1;  
    }
    
    void clearCount() {
      repelCount = 0;  
    }
    
    int repelCount() {
      return repelCount;
    }
    
    void draw() {
      
    };
    PVector[] getPoints() {
      return null;  
    };
    
    Map<String, Object> represent() {
      Map<String, Object> map = new HashMap<String, Object>();
      
      return map;
    }
}


class RectMask extends Mask {
  float x,y,w,h;

  public RectMask() {
    
  }
  
  public RectMask(PointBuffer pts) {
    PVector np1 = pts.pop();
    PVector np2 = pts.pop();
    x = min(np1.x, np2.x);
    y = min(np1.y, np2.y);
    w = abs(np1.x - np2.x);
    h = abs(np1.y - np2.y);
  }

  void draw() {
    fill(repelCount()>0 ? 50 : 0);
    stroke(255);
    rect(x,y,w,h);
    
    clearCount();  
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
    
    incCount();
  } 
 
  PVector[] getPoints() {
    PVector[] pts = new PVector[2];
    pts[0] = new PVector(x,y);
    pts[1] = new PVector(x+w,y+h);
    
    return pts;
  } 
  
   Map<String, Object> represent() {
      Map<String, Object> map = new HashMap<String, Object>();
      
      map.put("type", "RectMask");

      map.put("x", x/width);
      map.put("y", y/height);
      map.put("w", w/width);
      map.put("h", h/height);
        
      return map;
    }
    

}

class TriangleMask extends Mask {
  PVector[] points;

  public TriangleMask() {
    points = new PVector[3];    
  }

  public TriangleMask(PointBuffer pts) {
    points = new PVector[3];
    points[0] = pts.pop();
    points[1] = pts.pop();
    points[2] = pts.pop();
  }

  void draw() {
    fill(repelCount()>0 ? 50 : 0);
    stroke(255);
    beginShape();
    vertex(points[0].x, points[0].y);
    vertex(points[1].x, points[1].y);
    vertex(points[2].x, points[2].y);
    endShape(CLOSE);
    
    clearCount();  
  }

  void repel(Letter l) {
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
 
  PVector[] getPoints() {    
    return points;
  } 
  
  boolean inside(PVector p) {
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
  
     Map<String, Object> represent() {
      Map<String, Object> map = new HashMap<String, Object>();
      
      Float[] a;
      
      int i=0;
      
      map.put("type", "TriangleMask");
      
      
      for (PVector p : points) {
        a = new Float[2];
        a[0] = p.x / width;
        a[1] = p.y / height;
        
        map.put("p"+i, a);
        i+=1;
      }
      
        
      return map;
    }

}



