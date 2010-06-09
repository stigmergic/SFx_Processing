boolean resolve = false;
boolean drawimage = true;
boolean drawmasks = true;
boolean drawdebug = false;
boolean drawfilter = true;
boolean drawbackground = true;
boolean domouse = true;

float maxSpeed = 5.0;
float friction = 1.0;
float backAlpha = 255;
color  backColor = color(0);

public boolean isHighlightMode() {
  return FOCUSMODES[focus].equals("Highlight Mode");  
}

public static final String[] FOCUSMODES = {
  "Mask Mode",
  "Highlight Mode"
};

public static final int FIRST_FOCUS = 0;
public static final int LAST_FOCUS = FOCUSMODES.length-1;
int focus = FIRST_FOCUS;

public static final String[] MASKMODES = {
  "Rectangle",
  "Triangle"
};

public static final int FIRST_MASKMODE = 0;
public static final int LAST_MASKMODE = MASKMODES.length-1;
int maskmode = FIRST_MASKMODE;


void keyPressed() {
  if (highLightKeyPressed(key)) return;
  
  switch(key) {
    case 'b':
      drawbackground = !drawbackground;
      break;

    case 'v':
      backColor = color(0);
      break;

   case 'V':
      for (Letter l : letters) {
        l.co = color(255);  
      }
      break;

    case 'C':
      randomBackground();
      break;

     case 'c':
      for (Letter l : letters) {
        l.co = randomColor(backColor);  
      }
      break;

    case 'w':
      randomWords();
      break;

    case 'm':
      drawmasks = !drawmasks;
      break;
    case 's':
      drawdebug = !drawdebug;
      break;
    case 'f':
        letterFont = randomFont();
        break;
    case 'h':
      focus = focus + 1;
      if (focus>LAST_FOCUS) focus = FIRST_FOCUS;
      break;
    case 'H':
      focus = focus - 1;
      if (focus<FIRST_FOCUS) focus = LAST_FOCUS;
      break;
    case 'n':
      drawfilter = !drawfilter;
      break;
    case '-':
      bannerWidth -= 5;
      break;
    case '=':
      bannerWidth +=5;
      break;
      
    case '[':
      movingBannerX -= 5;
      break;
      
    case ']':
      movingBannerX += 5;
      break;
      
    case '{':
      movingBannerY -= 5;
      break;
    case '}':
      movingBannerY += 5;
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
      
    case '1':
      saveState("last.yaml");
      break;
    case '2':
      loadState("last.yaml", this);
      break;
    case ';':
      maxSpeed *= 1.01;
      println("Maxspeed: " + maxSpeed);
      break;
    case '\'':
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
    case ESC:
      saveState("last.yaml");
      exit();
      break;
    
    default:
      println("Key Pressed: " + key);
  }  
}
