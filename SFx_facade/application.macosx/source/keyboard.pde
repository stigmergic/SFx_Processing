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

public static final String[] MASKMODES = {
  "Rectangle",
  "Triangle"
};

public static final int FIRST_MASKMODE = 0;
public static final int LAST_MASKMODE = MASKMODES.length-1;
int maskmode = FIRST_MASKMODE;


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
      if (mousePoints.hasPoints()) {
        mousePoints.pop();
      } else {
        int i = masks.size()-1;
        if (i>=0) {
          Mask m = masks.get(i);
          mousePoints.add(m.getPoints());
          mousePoints.pop();
          masks.remove(i);
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
    case 'M':
      maskmode += 1;
      if (maskmode > LAST_MASKMODE) maskmode = FIRST_MASKMODE;
      break;      
    default:
      println("Key Pressed: " + key);
  }  
}
