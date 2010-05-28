boolean resolve = false;
boolean drawimage = true;
boolean drawmasks = true;
boolean drawdebug = false;
boolean drawfilter = true;
boolean drawbackground = true;
boolean domouse = true;

float maxSpeed = 5.0;
float backAlpha = 100;
color  backColor = color(0);

void keyPressed() {
  switch(key) {
    case 'b':
      drawbackground = !drawbackground;
      break;
    case 'c':
      backColor = randomColor();
      break;
    case 'm':
      drawmasks = !drawmasks;
      break;
    case 's':
      drawdebug = !drawdebug;
      break;
    case 'f':
        textFont(randomFont(), textHeight);
        break;
    case 'v':
      drawfilter = !drawfilter;
      break;
    case 'd':
      if (lastX>=0) {
        lastX = -1;
      } else {
        if (masks.size()>0) {
          Mask m = masks.get(masks.size()-1);
          lastX = m.x;
          lastY = m.y;
          masks.remove(m);
        }
      }
      
      break;
    case 'r':
      resolve = !resolve;
      break;
    case 'e':
      entrance();
      break;
    case 'i':
      drawimage = !drawimage;
      break;
    case ']':
      maxSpeed *= 1.01;
      println("Maxspeed: " + maxSpeed);
      break;
    case '[':
      maxSpeed *= 0.99;
      println("Maxspeed: " + maxSpeed);
      break;
    case ',':
      backAlpha = max(0, backAlpha-1);
      break;
    case '.':
      backAlpha = min(255, backAlpha+1);
      break;
      
    default:
      println("Key Pressed: " + key);
  }  
}
