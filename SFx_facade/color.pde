

 color randomColor() {
   colorMode(HSB);
   return color(random(255),255,255);
 }
 
 void randomFontColor() {
   for (Letter l : letters) {
      l.co = randomColor(backColor);  
   }
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

color randomRGBColor() {
  colorMode(RGB);
  return color(random(255),0,random(255));
}

  color randomBackgroundColor() {
    color c = randomRGBColor();
    
    return c;
  }

  
  void randomBackground() {
      backColor = randomBackgroundColor();
      for (Letter l : letters) {
        l.co = randomColor(backColor);  
      }
 
  }
