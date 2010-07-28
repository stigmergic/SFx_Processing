

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//BlobDetection by v3ga <http://processing.v3ga.net>
//May 2005
//Processing(Beta) v0.85
//
// Adding edge lines on the image process in order to 'close' blobs
//
// ~~~~~~~~~~
// software :
// ~~~~~~~~~~
// - Super Fast Blur v1.1 by Mario Klingemann <http://incubator.quasimondo.com>
// - BlobDetection library
//
// ~~~~~~~~~~
// hardware :
// ~~~~~~~~~~
// - Sony Eye Toy (Logitech)
//
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import processing.video.*;
import blobDetection.*;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
PImage diffImage;
PImage curFrame;
boolean newFrame=false;

boolean showdiffimage = true;
boolean showimage = false;

int numPixels;
int[] previousFrame;


// ==================================================
// setup()
// ==================================================
void setup()
{
  // Size of applet
  size(screenWidth, screenHeight);
  //size(640, 400);
  background(0);
  // Capture
  println(Capture.list());
  cam = new Capture(this, 640, 400,"Sony HD Eye for PS3 (SLEH 00201)", 30);
  //cam = new Capture(this, 320, 200,"Logitech QuickCam Pro 4000", 10);
  curFrame = new PImage(cam.width, cam.height);
  //cam = new Capture(this, 640, 480,"Sony", 15);
  // BlobDetection
  // img which will be sent to detection (a smaller copy of the cam frame);
  //img = new PImage(80,60); 
  img = new PImage(640,400); 

  diffImage = new PImage(cam.width, cam.height);

  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;

  numPixels = cam.width * cam.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();

  timeLapse();
}

// ==================================================
// captureEvent()
// ==================================================
void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}

// ==================================================
// draw()
// ==================================================
void draw()
{
  if (random(1) < 0.123) {
    fill(0,10);
    noStroke();
    rect(0,0,width,height);
  }
  if (newFrame)
  {
    movement();
    newFrame=false;

    img.copy(diffImage, 0, 0, width, height, 
    0, 0, img.width, img.height);

    fastblur(img, 2);
    theBlobDetection.computeBlobs(img.pixels);
    if (showdiffimage) image(diffImage, 0,0,width,height);

    if (showimage) image(img,0,0);
    drawBlobsAndEdges(true,true);
  }

  if (random(1)<0.01) image(cam,0,0,width,height);

  timeLapse();
}

