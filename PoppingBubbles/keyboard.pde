boolean showButtons=true;
boolean newFrame=false;
boolean darklight = true;
boolean drawtinted = true;
boolean drawimg2 = false;
boolean mirror = false;
boolean drawtrails = false;
boolean drawLines = false;
boolean drawBrains = false;
boolean drawBlobs = false;
boolean drawEdges = true;
boolean drawCenters = true;
float colorthresh = 0.2;
float redthresh = 0.2;
float bluethresh = 0.2;
float greenthresh = 0.2;
boolean showcam = false;
boolean layout = false;
boolean play_ping_pong = false;
boolean new_ball = false;
boolean record = false;
boolean doCalibration = false;
boolean drawgrayscale = false;
int tintHighlite = 15;

int COLOR = 1;
int RED = 2;
int GREEN = 4;
int BLUE = 8;

void keyPressed(){
  // change the edge detection lumens threshold
  if( key >= '0' && key <= '9') {
    colorthresh = 0.1*(key-48);
    redthresh = 0.1*(key-48);
    println("Threshold = " + colorthresh);
  } 
  else if (key == ESC){
    exit();
  } 
  else if (key == '<' || key == ','){
    colorthresh -= 0.001;
    colorthresh = colorthresh < 0 ? 0 : colorthresh;
    redthresh -= 0.001;
    redthresh = redthresh < 0 ? 0 : redthresh;
    println("Threshold = " + colorthresh);
   } 
  else if (key == '>' || key == '.'){
    colorthresh += 0.001;
    colorthresh = colorthresh > 1 ? 1.0 : colorthresh;
    redthresh += 0.001;
    redthresh = redthresh > 1 ? 1.0 : redthresh;
    println("Threshold = " + colorthresh);
  } 

  else if (key == 'g' || key == 'G') {
    drawgrayscale = !drawgrayscale;  
  } 
  else if (key == 'i' || key == 'I') {
    showcam = !showcam;  
  } 
  else if (key == ' ' || key == ' ') {
    drawtrails = !drawtrails;  
  } 
  else if (key == 9) {
    //TAB KEY
    showButtons = !showButtons;  
  } 
  else if (key == 'l' || key == 'L') {
    drawLines = !drawLines;  
  } 
  else if (key == 'p' || key == 'P') {
    layout = !layout;  
  } 
  else if (key == 'z' || key == 'Z') {
    trails = new ArrayList();  
  } 
  else if (key == '\\' || key == '\\') {
    record = !record;  
  } 
  else if (key == 'x' || key == 'X') {
    darklight = !darklight;  
    theBlobDetection.setPosDiscrimination(darklight);
  } 
  else if (key == 'b' || key == 'B') {
    drawBlobs = !drawBlobs;  
  } 
  else if (key == 'e' || key == 'E') {
     drawEdges = !drawEdges;
    } 
  else if (key == 'f' || key == 'F') {
     drawBrains = !drawBrains;
    } 
  else if (key == 'w' || key == 'W') {
     play_ping_pong = !play_ping_pong;
    } 
  else if (key == 'n' || key == 'N') {
     new_ball = true;
    } 
  else if (key == 'a' || key == 'A') {
     drawCenters = !drawCenters;
    } 
  else if (key == 'h' || key == 'H') {
     doCalibration = !doCalibration;
    } 
    
  else if (key == 'c' || key == 'C') {
    tintHighlite += 1;
    if (tintHighlite>15) tintHighlite = 0;  
  } 
  else if (key == 'D' || key == 'd') {
    drawimg2 = !drawimg2;      
  }
  else if (key == 'M' || key == 'm') {
    mirror = !mirror;      
  }
  else if (key == 't' || key == 'T') {
    drawtinted = !drawtinted;      
  }
  else {
    println("Key Pressed: " + int(key));
  }
}
