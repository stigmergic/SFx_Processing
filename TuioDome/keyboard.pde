
boolean drawids = false;
boolean drawpoints = false;
boolean drawrings = true;

void keyPressed() {
  if (key == ' ') {
    background(0,0,49);
  } else if (key == 'i') {
    drawids = !drawids;
  } else if (key == 'a') {
    drawpoints = !drawpoints;
  } else if (key == 'r') {
    drawrings = !drawrings;
  } else if (key == CODED) {
    if (keyCode == UP) centerY += screen.height/100.0; 
    if (keyCode == DOWN) centerY -= screen.height/100.0; 
    if (keyCode == LEFT) centerX -= screen.width/100.0; 
    if (keyCode == RIGHT) centerX += screen.width/100.0; 
   
  } 
}

