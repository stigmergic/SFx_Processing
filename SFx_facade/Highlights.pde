ArrayList<HighLight> highlights;
HighLight currentHighLight;

public void setupHighLights() {
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



public class HighLight {
  ArrayList<PVector> points;
  color myColor;
  int thickness;

  public HighLight() {
    points = new ArrayList();
    colorMode(RGB);
    myColor = color(255);
    thickness = 3;
  }  
  
  public void add(PVector p) {
    points.add(p);  
  }
  
  public void pop() {
    if (points.size()>0) points.remove(points.size()-1);  
  }
  
  public void drawLines() {
    PVector op = null;
    for (PVector p : points) {
      if (op != null) line(p,op);
      op = p;
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
  
}
