

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

