

 color randomColor() {
   colorMode(HSB);
   return color(random(255),255,255);
 }

  color randomColor(color avoid) {
    colorMode(HSB);
    float h = hue(avoid);
    color c = randomColor();
    while (abs(hue(c) - h)<30) {
      c = randomColor();
    }
    
    return c;
  }
