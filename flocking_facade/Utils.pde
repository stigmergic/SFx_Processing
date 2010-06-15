public Vector randomUnitVector() {
  float a = random(2*PI);
  return new Vector(cos(a), sin(a));  
}

public Vector sub(Vector v1, Vector v2) {
  Vector dir = new Vector(v2.x-v1.x, v2.y-v1.y);

  return dir;
}

public Vector direction(Vector v1, Vector v2) {
  Vector dir = sub(v1, v2);
  dir.normalize();

  return dir;  
}


public float distance(Vector v1, Vector v2) {
  return sqrt(sq(v1.x-v2.x) + sq(v1.y-v2.y));  
}

void ellipse(Vector v, int diameter) {
  ellipse(v.x, v.y, diameter, diameter);  
}

void line(Vector v1, Vector v2) {
  line(v1.x, v1.y, v2.x, v2.y);  
}
