
void setupKeyboard() {

  states.set("drawimage", true);
  states.set("drawmasks", true);
  states.set("drawdebug", false);
  states.set("drawfilter", true);
  states.set("drawbackground", true);
  states.set("domouse", true);
}

float maxSpeed = 5.0;
float friction = 1.0;
float backAlpha = 255;
color  backColor = color(0);
color dropColor = color(0);
int resolution = 0;

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

public static final int SOLID_RESOLUTION = 0;
public static final int WAVE_RESOLUTION = 1;
public static final int SHAKY_RESOLUTION = 2;
public static final int ROTAIONAL_RESOLUTION = 4;
public static final int BLINKING_RESOLUTION = 8;
public static final int LAST_RESOLUTION = 15;




void keyPressed() {
  if (isHighlightMode() && highlights.highLightKeyPressed(key)) return;
  
  switch(key) {
    case 't':
      resolution += 1;
      if (resolution>LAST_RESOLUTION) resolution =0;
      break;
    
    case 'b':
      flip("drawbackground");
      break;

    case 'v':
      backColor = color(0);
      break;

   case 'V':
      for (Letter l : letters) {
        if (l.co == color(0)) {
          l.co = color(255);  
        } else {
          l.co = color(0);  
        }
      }
      break;

    case 'C':
      randomBackground();
      break;

     case 'c':
      randomFontColor();
      break;

    case 'x':
      if (dropColor == color(0)) {
        dropColor = color(255);
      } else {
        dropColor = color(0);
      }
      break;
    case 'X':
      dropColor = randomColor();
      break;
      

    case 'w':
      randomWords();
      break;

    case 'm':
      flip("drawmasks");
      break;
    case 's':
      flip("drawdebug");
      break;
    case 'a':
      fonts.letterFont.incrType();
      break;
    case 'f':
        fonts.letterFont = fonts.nextFont();
        fonts.setFont();
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
      flip("drawfilter");
      break;
    case 'N':
      flip("changingbackground");
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
      println("delete point");
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
      flip("resolve");
      break;
    case 'e':
      randomEntrance();
      break;
    case 'i':
      flip("drawimage");
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
