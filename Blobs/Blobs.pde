

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
	//size(screenWidth, screenHeight);
	size(640, 400);
        background(0);
	// Capture
        println(Capture.list());
	//cam = new Capture(this, 640, 400,"Sony HD Eye for PS3 (SLEH 00201)", 15);
	cam = new Capture(this, 320, 200,"Logitech QuickCam Pro 4000", 10);
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
                
		//image(cam,0,0,width,height);
		
                img.copy(diffImage, 0, 0, width, height, 
				0, 0, img.width, img.height);

                fastblur(img, 2);
		theBlobDetection.computeBlobs(img.pixels);
                if (showdiffimage) image(diffImage, 0,0,width,height);

                if (showimage) image(img,0,0);
		drawBlobsAndEdges(true,true);
        
	}

timeLapse();
}

// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
	noFill();
	Blob b;
	EdgeVertex eA,eB;
	for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
	{
		b=theBlobDetection.getBlob(n);
		if (b!=null)
		{
			// Edges
			if (drawEdges)
			{
				strokeWeight(1);
				stroke(255,255,0);
				for (int m=0;m<b.getEdgeNb();m++)
				{
					eA = b.getEdgeVertexA(m);
					eB = b.getEdgeVertexB(m);
					if (eA !=null && eB !=null)
						line(
							eA.x*width, eA.y*height, 
							eB.x*width, eB.y*height
							);
				}
			}

			// Blobs
			if (drawBlobs)
			{
				strokeWeight(1);
				stroke(255,0,0);
                                fill(255,60);
				rect(
					b.xMin*width,b.yMin*height,
					b.w*width,b.h*height
					);

                                int x1 = (int) b.xMin*width;
                                int y1 = (int) b.yMin*height;
                                int w1 = (int) b.w*width;
                                int h1 = (int) b.h*height;
                                
                                int x2 = (int) b.xMin*cam.width;
                                int y2 = (int) b.yMin*cam.height;
                                int w2 = (int) b.w*cam.width;
                                int h2 = (int) b.h*cam.height;

				copy(curFrame,x2,y2,w2,h2,x1,y1,w1,h1);
			}

		}

      }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}
