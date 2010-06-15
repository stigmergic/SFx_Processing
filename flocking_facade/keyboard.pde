boolean pause = false;
boolean showneighborhood = false;
boolean showvelocity = true;
boolean showinfluence = true;
boolean showagent = true;
boolean avoidmouse = false;
boolean drawbackground = true;
boolean boidswalk = false;
boolean addboid = false;
boolean dropobstacles = false;
boolean drawhistory = false;


void setMessage() {
  message = "";

  if (!(avoidanceWeight>0 && centerWeight>0 && alignWeight>0)) {
    if (avoidanceWeight>0) message += " Avoidance ";
    if (centerWeight>0) message += " Center ";
    if (alignWeight>0) message += " Align ";   
    
    if (message.equals("")) message = " no rules "; 

  } else {
    //Message  
  }


}

void keyPressed() {
  if (showhelppanel) {
    showhelppanel = false;

  }
  
  process( key,  keyCode);
} 

void process(char key, int keyCode) {
  switch (key) {
  case '/':
  case '?':
    showhelppanel = true;
    break;

  case '1':
    avoidanceWeight = saveAvoidanceWeight;
    centerWeight = saveCenterWeight;
    alignWeight = saveAlignWeight;
    setMessage();
    break;
  case '2':
    if (avoidanceWeight>0) {
      avoidanceWeight = 0;
    } 
    else {
      avoidanceWeight = saveAvoidanceWeight;
    }
    setMessage();
    break;
  case '3':
    if (centerWeight>0) {
      centerWeight = 0;
    } 
    else {
      centerWeight = saveCenterWeight;
    }
    setMessage();
    break;
  case '4':
    if (alignWeight>0) {
      alignWeight = 0;
    } 
    else {
      alignWeight = saveAlignWeight;
    }
    setMessage();
    break;


  case ' ':
    pause = !pause;
    break;

  case 'n':
  case 'N':
    showneighborhood = !showneighborhood;
    break;

  case 'v':
  case 'V':
    showvelocity = !showvelocity;
    break;

  case 'i':
  case 'I':
    showinfluence = !showinfluence;
    break;

  case 'm':
  case 'M':
    avoidmouse = !avoidmouse;
    break;

  case 'o':
  case 'O':
    dropobstacles = !dropobstacles;
    break;

  case 'a':
  case 'A':
    showagent = !showagent;
    break;

  case 'b':
  case 'B':
    drawbackground = !drawbackground;
    break;

  case 'k':
    boids.removeOne();
    break;

  case 'K':
    boids.removeAll();
    break;
 
  case 'g':
    if (backgroundColor == color(0)) {
      backgroundColor = color(255);
    } else {
      backgroundColor = color(0);
    }
    break;
    
  case 'l':
    drawhistory = !drawhistory;
    break;
    
  case '{':
    historyLength = max(historyLength - 1, 0);
    break;
  
  case '}':
    historyLength++;
    break;

  case 's':
    boids.addBoid(new Vector(mouseX, mouseY));  
    break;

  case 'S':
    addboid = !addboid;
    break;

  case 'u':
    obstacles.addSource(mouseX, mouseY);
    break;

  case 'U':
    obstacles.addSink(mouseX, mouseY);
    break;

  case 'x':
  case 'X':
    obstacles.clear(); 
    break;

  case 'e':
    obstacles.lastLocation = null;
    break;

  case 'r':
  case 'R':
    noiseWeight = (noiseWeight > 0) ? 0.0 : 1.0;
    break;

  case 'w':
  case 'W':
    boidswalk = !boidswalk;
    break;

  case 'z':
  case 'Z':
    boids.setVelocity(new Vector(0,0));
    break;

  case 'q':
  case 'Q':
    boids.setRandomLocation();
    break;

  case '<':
    boidSize -= 1;
    boidSize = constrain(boidSize,minBoidSize,maxBoidSize);
    updateNeighborhood();
    break;
  case '>':
    boidSize += 1;
    boidSize = constrain(boidSize,minBoidSize,maxBoidSize);
    updateNeighborhood();
    break;

  case CODED:
    switch (keyCode) {
    case UP:
      boids.addInfluence(new Vector(0, -0.5));
      break;

    case DOWN:
      boids.addInfluence(new Vector(0, 0.5));
      break;

    case RIGHT:
      boids.addInfluence(new Vector(0.5, 0));
      break;

    case LEFT:
      boids.addInfluence(new Vector(-0.5, 0));
      break;

    default:
      println("Coded key pressed: <" + keyCode + "> ");
    }
    break;

  default:
    println("Key Pressed: <" + key + ">");
  }  

  loop();
}


void randomKey() {
  int i = (int) random(100);
  
  switch (i) {
    case 1:
      process('1', 0);
      break;  
    case 2:
      process('2', 0);
      break;  
    case 3:
      process('3', 0);
      break;  
    case 4:
      process('4', 0);
      break;  
    case 5:
      process('5', 0);
      break;
    case 6:
      process('n', 0);
      break;
    case 7:
      process('s', 0);
      break;
    case 8:
      process('i', 0);
      break;
    case 9:
      process('v', 0);
      break;
    case 10:
      process('b', 0);
      break;
    case 11:
      process('<', 0);
      break;
    case 12:
      process('>', 0);
      break;
    case 13:
      process('w', 0);
      break;
    case 14:
      process('r', 0);
      break;
    case 15:
      process('z', 0);
      break;
    case 16:
      process('q', 0);
      break;
    case 17:
      process((char) CODED, UP);
      break;
    case 18:
      process((char) CODED, DOWN);
      break;
    case 19:
      process((char) CODED, LEFT);
      break;
    case 20:
      process((char) CODED, RIGHT);
      break;
    case 21:
      process('k', 0);
      break;
    case 22:
      process('a', 0);
      break;
    case 23:
      process('l', 0);
      break;
    case 24:
      process('{', 0);
      break;
    case 25:
      process('}', 0);
      break;

      
    
  }
  
}


