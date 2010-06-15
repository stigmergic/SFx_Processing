Highlights highlights;

public class Highlights {
ArrayList<HighLight> highlights;
HighLight currentHighLight = null;
float minHighlightDist = 5;

public  Highlights() {
  highlights = new ArrayList<HighLight>();
}

public void drawHighlights() {
  for (HighLight h : highlights) {
    if (h == currentHighLight) h.highlight();
    h.draw();
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
    //getCurrentHighLight().add(new PVector(mouseX, mouseY)); 
   currentHighLight = null; 
  }
  
  public boolean highLightKeyPressed(char c) {
    switch (key) {
      case 'd':
        getCurrentHighLight().pop();
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
        getCurrentHighLight().myColor = randomColor();
        return true;
      
    }
    
    return false;
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
      if (map.containsKey("myColor")) h.myColor = (Integer) map.get("myColor");
      if (map.containsKey("thickness")) h.thickness = (Integer) map.get("thickness");
      if (map.containsKey("points")) h.points = (List<PVector>) map.get("points");
      highlights.add(h);
      
    }  
  }
}


public class HighLight {
  List<PVector> points;
  color myColor;
  int thickness;

  public HighLight() {
    points = new ArrayList();
    colorMode(RGB);
    myColor = color(255);
    thickness = 3;
  }  
  
  public void add(PVector p) {
    if (points.size()<2) {
      points.add(p);
      return;
    }
    
    PVector p1 = points.get(points.size()-2);
    PVector p2 = points.get(points.size()-1);
    PVector p3 = p;
    
    float d1 = dist(p1,p2);
    float d2 = dist(p1,p3);
    
    
    if (d2 < highlights.minHighlightDist || (d1/d2) < 0.5) {
       pop();     
    }

    points.add(p);  
    
    System.out.println("points: " + points.size());
  }
  
  public void pop() {
    if (points.size()>0) points.remove(points.size()-1);  
  }
  
  public void drawLines() {
    PVector op = null;
    for (PVector p : points) {
      if (op != null) line(p,op);
      op = p;
      //ellipse(p.x,p.y,5,5);
    }

  }
  
  public void highlight() {
    colorMode(RGB);
    strokeWeight(thickness + 2);
    color(255);
    drawLines();
    strokeWeight(1); 
    
    strokeWeight(thickness + 1);
    color(0);
    drawLines();
    strokeWeight(1);  
    
  }
  
  public void draw() {
    strokeWeight(thickness);
    color(myColor);
    drawLines();
    strokeWeight(1);  
  }
 
  public Map represent() {
    HashMap<String, Object> map = new HashMap<String, Object>();
    map.put("myColor", myColor);
    map.put("thickness", thickness);
    map.put("points", points);
    return map; 
  } 
  
  
}
