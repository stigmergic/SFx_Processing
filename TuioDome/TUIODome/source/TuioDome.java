import processing.core.*; 
import processing.xml.*; 

import tuio.*; 

import com.illposed.osc.utility.*; 
import com.illposed.osc.*; 
import tuio.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TuioDome extends PApplet {



TuioClient tuioClient;

float cursor_size = 10;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;

PFont font;

float centerX, centerY;
float a = 0;
float da = PI/16;



public void setup()
{
  //size(screen.width,screen.height);
  size(screen.width, screen.height);
  centerX = screen.width/2;
  centerY = screen.height/2;

  noStroke();
  fill(0);

  loop();
  background(0,0,50);

  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  // an instance of the TuioClient
  // since we ad "this" class as an argument the TuioClient expects
  // an implementation of the TUIO callback methods (see below)
  tuioClient  = new TuioClient(this);
}


// within the draw method we retrieve an array of TuioObject and TuioCursor 
// from the TuioClient and then loop over both lists to draw the graphical feedback.
public void draw()
{
  //background(0,10);
  fill(0,1);
  noStroke();
  rect(0,0,width, height);

  textFont(font,18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  TuioObject[] tuioObjectList = tuioClient.getTuioObjects();
  for (int i=0;i<tuioObjectList.length;i++) {
    TuioObject tobj = tuioObjectList[i];
    stroke(0);
    fill(0);
    pushMatrix();
    translate(tobj.getScreenX(width),tobj.getScreenY(height));
    rotate(tobj.getAngle());
    rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
    popMatrix();
    fill(255);
    text(""+tobj.getFiducialID(), tobj.getScreenX(width), tobj.getScreenY(height));
  }

  TuioCursor[] tuioCursorList = tuioClient.getTuioCursors();

  if (tuioCursorList.length == 0) {
    randomizeColors();
  }

  for (int i=0;i<tuioCursorList.length;i++) {
    int c1 = getColor(i);
    TuioCursor tcur = tuioCursorList[i];
    TuioPoint[] pointList = tcur.getPath();
    if (pointList.length>0) {
      TuioPoint start_point = pointList[0];
      for (int j=0;j<pointList.length;j++) {
        TuioPoint end_point = pointList[j];
        stroke(c1);
        strokeWeight(2);
        //line(start_point.getScreenX(width),start_point.getScreenY(height),end_point.getScreenX(width),end_point.getScreenY(height));
        //line(centerX,centerY,end_point.getScreenX(width),end_point.getScreenY(height));
        start_point = end_point;
      }

      stroke(192,192,192);
      fill(192,192,192);
      fill(c1);
      noStroke();
      //ellipse( tcur.getScreenX(width), tcur.getScreenY(height),cur_size,cur_size);
      noFill();
      strokeWeight(5);
      stroke(c1);

      if (drawrings) {
        float d = dist(width/2, height/2,tcur.getScreenX(width), tcur.getScreenY(height)) * 2;
        float dx = d/5;
        float cx = 0;
        while (cx<=d) {
          line(centerX, centerY, centerX + cx * cos(a)/2, centerY + cx * sin(a)/2);
          ellipse(centerX, centerY,cx,cx);
          cx += dx;
          a += da;
        }
      }

      if (drawpoints) {
        fill(0);
        ellipse(tcur.getScreenX(width),  tcur.getScreenY(height), 36, 36);
      }

      if (drawids) {
        fill(255);
        text(""+ tcur.getFingerID(),  tcur.getScreenX(width)-5,  tcur.getScreenY(height)+5);
      }
    }
  }
}

ArrayList colors = new ArrayList();

public int getRandomColor() {
  return color(random(255), random(255), random(255), 50);  
}

public int getColor(int i) {
  while (colors.size() <= i)  {
    colors.add(new Integer( getRandomColor() ));
  }
  
  return (Integer) colors.get(i);
}

public void setColor(int i, int c) {
  while (colors.size() <= i)  {
    colors.add(new Integer( getRandomColor() ));
  }
  
  colors.set(i,c);
}


public void randomizeColors() {
  for (int i=0; i<colors.size(); i++) {
    setColor(i, getRandomColor());
  }  
}


boolean drawids = false;
boolean drawpoints = false;
boolean drawrings = true;

public void keyPressed() {
  if (key == ' ') {
    background(0,0,49);
  } else if (key == 'i') {
    drawids = !drawids;
  } else if (key == 'a') {
    drawpoints = !drawpoints;
  } else if (key == 'r') {
    drawrings = !drawrings;
  } else if (key == CODED) {
    if (keyCode == UP) centerY += screen.height/100.0f; 
    if (keyCode == DOWN) centerY -= screen.height/100.0f; 
    if (keyCode == LEFT) centerX -= screen.width/100.0f; 
    if (keyCode == RIGHT) centerX += screen.width/100.0f; 
   
  } 
}


// these callback methods are called whenever a TUIO event occurs

// called when an object is added to the scene
public void addTuioObject(TuioObject tobj) {
  println("add object "+tobj.getFiducialID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is removed from the scene
public void removeTuioObject(TuioObject tobj) {
  println("remove object "+tobj.getFiducialID()+" ("+tobj.getSessionID()+")");
}

// called when an object is moved
public void updateTuioObject (TuioObject tobj) {
  println("update object "+tobj.getFiducialID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
public void addTuioCursor(TuioCursor tcur) {
  println("add cursor "+tcur.getFingerID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
public void updateTuioCursor (TuioCursor tcur) {
  println("update cursor "+tcur.getFingerID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}


// called when a cursor is removed from the scene
public void removeTuioCursor(TuioCursor tcur) {
  println("remove cursor "+tcur.getFingerID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
public void refresh(long timestamp) { 
  //redraw();
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "TuioDome" });
  }
}
