
public class Vector {
  float x, y;

  public Vector() {
    x = 0;
    y = 0;  
  }

  public Vector(float _nx, float _ny) {
    x = _nx;
    y = _ny;  
  }

  public float magnitude() {
    return sqrt(sq(x) + sq(y));  
  }

  public Vector normalize() {
    float len = magnitude();
    if (len < epsilon) return this;
    return scale(1/len);
  }

  public Vector add(Vector v) {
    return set(x + v.x, y + v.y); 
  }

  public Vector scale(float f) {
    return set(x*f, y*f);
  } 

  public Vector set(float nx, float ny) {
    x = nx;
    y = ny;

    return this;
  }

  public Vector set(Vector v) {
    x = v.x;
    y = v.y;

    return this;  
  }

  public Vector copy() {
    return new Vector(x,y);  
  }
}


