Highlights highlights;
color highlightcolor = color(255);

void deleteHighlights() {
  highlights.deleteAll();  
}

public class Highlights {
ArrayList<HighLight> highlights;
HighLight currentHighLight = null;
float minHighlightDist = 5;

public  Highlights() {
  highlights = new ArrayList<HighLight>();
}

public void drawHighlights() {
  
  for (HighLight h : highlights) {
    if (h == currentHighLight) {
      h.highlight();
    } else {
      h.draw();
    }
  }  

}

  public HighLight getCurrentHighLight() {
    if (currentHighLight == null) {
      currentHighLight = new HighLight();
      highlights.add(currentHighLight);
    }  
    
    return currentHighLight;
  }

  public void highLightMousePressed() {
   if (mouseButton == RIGHT) currentHighLight = null; 
   else getCurrentHighLight().add(new PVector(mouseX, mouseY)); 
  }
  
  public boolean highLightKeyPressed(char c) {
    switch (key) {
      case 'd':
        getCurrentHighLight().pop();
        if (getCurrentHighLight().points.size() == 0) {
          highlights.remove(getCurrentHighLight());
          if (highlights.size()>0) {
            currentHighLight = highlights.get(highlights.size()-1);
          }
            
        }
        return true;
      case '+':
      case '=':
        getCurrentHighLight().thickness += 1;
        return true;
      case '-':
      case '_':
        getCurrentHighLight().thickness = max(getCurrentHighLight().thickness - 1, 1);
        return true;
      case 'c':
        highlightcolor = randomColor();
        return true;
      
    }
    
    return false;
  }
  
  void deleteAll() {
    highlights.clear();  
  }
  
  public List represent() {
    ArrayList<Map> list = new ArrayList<Map>();
    
    for (HighLight h : highlights) {
      list.add(h.represent());  
    }
  
    return list;  
  }
  
  public void apply(List list) {
    for (Object o : list) {
      Map<String, Object> map = (Map<String, Object>) o;
      HighLight h = new HighLight();
      if (map.containsKey("thickness")) h.thickness = (Integer) map.get("thickness");
      if (map.containsKey("points")) {
        h.points = new ArrayList<PVector>();
        
        for (PVector point : (List<PVector>) map.get("points")) {
          h.points.add(new PVector(point.x * width, point.y * height));  
        }
      }
      highlights.add(h);
      
    }  
  }
}


public class HighLight {
  List<PVector> points;
  int thickness;

  public HighLight() {
    points = new ArrayList();
    colorMode(RGB);
    thickness = 7;
  }  
  
  public void add(PVector p) {
      points.add(p);
      return;
  }
  
  public void pop() {
    if (points.size()>0) points.remove(points.size()-1);  
  }
  
  public void drawLines() {
    PVector op = null;
    
    
    for (PVector p : points) {
      if (op != null) line(p.x, p.y, op.x, op.y);
      op = p;
      //ellipse(p.x,p.y,5,5);
    }
    
  }
  
  public void highlight() {
    colorMode(RGB);
    strokeWeight(thickness + 2);
    stroke(highlightcolor);
    drawLines();
    strokeWeight(1); 
    
    strokeWeight(thickness - 1);
    stroke(0);
    drawLines();
    strokeWeight(1);
  
    if (points.size()>0) {
      PVector p = points.get(points.size()-1);
    strokeWeight(thickness + 2);
    stroke(highlightcolor);
      line(p.x,p.y,mouseX,mouseY);  
    strokeWeight(thickness - 1);
    stroke(0);
      line(p.x,p.y,mouseX,mouseY);  
    
    }
    
    strokeWeight(1);
  }
  
  public void draw() {

    strokeWeight(thickness);
    stroke(highlightcolor);
      drawLines();
    
    strokeWeight(1);
  
  }
 
  public Map represent() {
    HashMap<String, Object> map = new HashMap<String, Object>();
    map.put("thickness", thickness);
    
    ArrayList<PVector> scaledPoints = new ArrayList();
    for (PVector point : points) {
      scaledPoints.add(new PVector(point.x/width, point.y/height));  
    }
    
    map.put("points", scaledPoints);
    return map; 
  } 
  
  public void smooth() {
    
  }
  
  
}
