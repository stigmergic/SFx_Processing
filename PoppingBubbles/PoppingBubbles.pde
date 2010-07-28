/**********************************************************
 *
 *  Based on CamDemo by Joshua Thorp, 2006
 *  jthorp@redfish.com
 *  copyright 2010  by Joshua Thorp StigmergicProductions
 *  joshua@stigmergic.net
 *
 *  V300
 **********************************************************/

import processing.video.*;
import blobDetection.*;
import java.util.ArrayList;

public class PoppingBubbles extends PApplet {

Capture cam;
BlobDetection theBlobDetection;
ArrayList whiteBlobs;
ArrayList redBlobs;
ArrayList greenBlobs;
ArrayList blueBlobs;

PFont font = new PFont();

PImage img,redimg,blueimg,greenimg,blackimg;
PGraphics scratch = createGraphics(1000,1000,P3D);
PImage t;
int alphaLevel = 100;

void setup()
{
  // Size of applet
  //size(1600,1000);
  //size(2560,800);
  //size(800,600);
  size(screenWidth, screenHeight);
  
  println(Capture.list());
  //cam = new Capture(this, 324, 240, 15);
  //cam = new Capture(this, 320, 200,"Logitech QuickCam Pro 4000", 10);

  cam = new Capture(this, 324, 240,"Sony HD Eye for PS3 (SLEH 00201)", 25);
  
  int res = 2;
  // BlobDetection
  img = new PImage(160*res,120*res); // img which will be sent to detection (a smaller copy of the cam frame);
  redimg = new PImage(160*res,120*res); 
  blueimg = new PImage(160*res,120*res); 
  greenimg = new PImage(160*res,120*res); 
  blackimg = new PImage(160*res,120*res);

  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(darklight);

  t = new PImage(width,height);
  setupsound();
  guiSetup();
}

void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}

color getWhite() {
  return color(255,alphaLevel);
}

color getRed() {
  if (drawgrayscale) 
    return color(100,alphaLevel);
  return color(255,0,0,alphaLevel);
}
color getGreen() {
  if (drawgrayscale) 
    return color(200,alphaLevel);
  return color(0,255,0,alphaLevel);
}
color getBlue() {
  if (drawgrayscale) 
    return color(255,alphaLevel);
  return color(0,0,255,alphaLevel);
}
  
void draw()
{
  if (newFrame)
  {
    getFrame();
    blobDetectImages();
    background(0);

    if (doCalibration) {
      calibrationStep();
      
    }

    if (showcam) {
      image(t,0,0,width,height);
    } 


    if (drawEdges) {
      drawEdges(whiteBlobs, getWhite());  
      drawEdges(redBlobs, getRed());  
      drawEdges(greenBlobs, getGreen());  
      drawEdges(blueBlobs, getBlue());  
    }    

    if (drawBlobs) {
      drawBlobs(whiteBlobs, getWhite());  
      drawBlobs(redBlobs, getRed());    
      drawBlobs(greenBlobs,  getGreen());   
      drawBlobs(blueBlobs, getBlue());      
    }

    if (drawCenters) {
      drawCenters(whiteBlobs, getWhite(),5);  
      drawCenters(redBlobs, getRed(),5);  
      drawCenters(greenBlobs,  getGreen()  ,5);  
      drawCenters(blueBlobs,getBlue(),5);            
    }

    if (drawtrails) {
      spawnBubbles(redBlobs,getRed());
      spawnBubbles(greenBlobs,getGreen());
      spawnBubbles(blueBlobs,getBlue());

      bubblestep(); 
    }

    if (play_ping_pong) {
      ping_pong_step();
    }

    if (drawimg2) {
      int xmargin = int( ((float)width/img.width)/3.0/2 ) ;
      int ymargin = (int) (height/img.height/3.0/2) ;
      float m = min(width/2.0/img.width, height/2.0/img.height);
      stroke(100);
      noFill();
      if ((tintHighlite & COLOR)>0){
        rect(0-1+xmargin,0-1+ymargin,img.width*m+2,img.height*m+2);        
        image(img,0+xmargin,0+ymargin,img.width*m,img.height*m);
      }
      if ((tintHighlite & RED)>0){
        rect(0-1+xmargin,height/2-1+ymargin,img.width*m+2,img.height*m+2);        
        image(redimg,0+xmargin,height/2+ymargin,img.width*m, img.height*m);
      }
      if ((tintHighlite & BLUE)>0){
        rect(width/2-1+xmargin,0-1+ymargin,img.width*m+2,img.height*m+2);        
        image(blueimg,width/2+xmargin,0+ymargin,img.width*m, img.height*m);
      }
      if ((tintHighlite & GREEN)>0){
        rect(width/2-1+xmargin,height/2-1+ymargin,img.width*m+2,img.height*m+2);        
        image(greenimg,width/2+xmargin,height/2+ymargin,img.width*m, img.height*m);
      }
    }
    if (record)
      saveFrame("blobs-######.tga");
    if (showButtons) drawButtons();
    println();
  }
}

void blankScreen() {
  drawimg2 = false;
  play_ping_pong = false;
  drawtrails = false;  
  drawCenters = false;
  drawBlobs = false;
  drawEdges = false;
  showButtons = false;
}

void getFrame() {
  newFrame=false;
  if (mirror) {
    scratch.background(0);
    scratch.pushMatrix();
    scratch.scale(-1,1);
    scratch.translate(width * -1,0);
    scratch.image(cam,0,0,width,height);
    t.copy(scratch,0,0,width,height,0,0,width,height);
    t.updatePixels();
    scratch.popMatrix();
  } 
  else {
    t.copy(cam,0,0,cam.width,cam.height,0,0, t.width, t.height);
    t.updatePixels();
  }

}

void blobDetectImages() {
  whiteBlobs = new ArrayList();
  redBlobs = new ArrayList();
  blueBlobs = new ArrayList();
  greenBlobs = new ArrayList();

  img.copy(t, 0, 0, t.width, t.height, 0, 0, img.width, img.height);

  if ((tintHighlite & COLOR) > 0) {
    fastblur(img, 2);
    img.updatePixels();
    theBlobDetection.setThreshold(colorthresh);
    theBlobDetection.computeBlobs(img.pixels);
    saveBlobs(whiteBlobs);
  } 

  if ((tintHighlite & RED)>0) {
    redimg.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
    redimg.updatePixels();
    fastred(redimg);
    fastblur(redimg, 2);
    redimg.updatePixels();
    theBlobDetection.setThreshold(redthresh);
    theBlobDetection.computeBlobs(redimg.pixels);
    saveBlobs(redBlobs);
  }
  else {
    redimg.copy(blackimg, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

  }
  if ((tintHighlite & GREEN)>0) {

    greenimg.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
    greenimg.updatePixels();
    fastblur(greenimg, 2);
    fastgreen(greenimg);
    greenimg.updatePixels();
    theBlobDetection.setThreshold(greenthresh);
    theBlobDetection.computeBlobs(greenimg.pixels);
    saveBlobs(greenBlobs);
  }
  else {
    greenimg.copy(blackimg, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

  }
  if ((tintHighlite & BLUE)>0) {

    blueimg.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
    blueimg.updatePixels();
    fastblue(blueimg);
    fastblur(blueimg, 2);
    blueimg.updatePixels();
    theBlobDetection.setThreshold(bluethresh);
    theBlobDetection.computeBlobs(blueimg.pixels);
    saveBlobs(blueBlobs);
  }
  else {
    blueimg.copy(blackimg, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

  }

  print("Num Blobs...white:" + whiteBlobs.size() + " red:" + redBlobs.size() + " green:" + greenBlobs.size() + " blue:" + blueBlobs.size());
}

void saveBlobs(ArrayList blobList) {
  Blob b;
  MyBlob mb;
  for (int n=0; n<theBlobDetection.getBlobNb() ; n++) {
    b = theBlobDetection.getBlob(n);
    mb = new MyBlob(b);
    blobList.add(mb);    
  }  
}

void drawEdges(ArrayList blobList, color c) {
  MyBlob b;
  EdgeVertex eA,eB;
  MyEdge e;
  DoubleMatrix2D pt1,pt2; 
  strokeWeight(2);
  stroke(c);

  for (int i=0; i<blobList.size(); i++) {
    b = (MyBlob) blobList.get(i);    
    for (int m=0;m<b.numEdges();m++)
    {
      e = b.getEdge(m);
      pt1 = getPoint(e.x1*width, e.y1*height);
      pt1 = getCamToProj(pt1);
      pt2 = getPoint(e.x2*width, e.y2*height);
      pt2 = getCamToProj(pt2);      
      line((float)pt1.get(0,0),(float)pt1.get(1,0),(float)pt2.get(0,0),(float)pt2.get(1,0) );
    }

  }  
}

void drawBlobs(ArrayList blobList, color c) {
  MyBlob b;
  noStroke();
  fill(c);

  for (int i=0; i<blobList.size(); i++) {
    b = (MyBlob) blobList.get(i);    
    rect(b.xMin*width,b.yMin*height,(b.xMax-b.xMin)*width,(b.yMax-b.yMin)*height);
  }  

}

void drawCenters(ArrayList blobList, color c, int radius) {
  MyBlob b;
  noStroke();
  fill(c);

  for (int i=0; i<blobList.size(); i++) {
    b = (MyBlob) blobList.get(i);    
    ellipse(b.centerX()*width, b.centerY()*height,radius,radius);
  }  
}





