import processing.core.*; 
import processing.xml.*; 

import oscP5.*; 
import netP5.*; 

import oscP5.*; 
import netP5.*; 

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

public class OSC_dometest extends PApplet {

/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */




float offA = PI;

float a = 55;
float ax, ay, az;
float anglex, angley, anglez;

float cax,cay,caz;

OscP5 oscP5;


public void setup() {
  size(screen.width,screen.height);
  
  strokeWeight(2);
  frameRate(25);
  
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,3333);
  
  
}



public void draw() {
  fill(0,1);
  noStroke();
  rect(0,0,width,height);
  
  stroke(255);
  noFill();
  float X = width/2;
  float Y = height/2;
  float S = min(width/2, height/2);
  
  drawCircle(X,Y,S * cax, anglex, color(255,0,0,a));
  drawCircle(X,Y,S * cay, angley, color(0,255,0,a));
  drawCircle(X,Y,S * caz, anglez, color(0,0,255,a));
  
  if (ax>cax) cax += 1; 
  if (ax<cax) cax -= 1; 
  if (ay>cay) cay += 1; 
  if (ay<cay) cay -= 1; 
  if (az>caz) caz += 1; 
  if (az<caz) caz -= 1; 

}

public void drawCircle(float X, float Y, float S, float angle, int c) {
  stroke(c);
  ellipse(X, Y, ax * S, ax * S);
  
  line(X, Y,X  * width * cos(-angle+offA), Y  * height * sin(-angle+offA));  
}

public void mousePressed() {
}


public void keyPressed() {
  switch(key) {
    case('c'):
      break;
    case('d'):
      break;
    case('.'):
      offA += 0.1f;
      break;
    case(','):
      offA -= 0.1f;
      break;

  }  
}


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
  
  if (theOscMessage.addrPattern().equals("/acceleration/xyz")){
    ax = theOscMessage.get(0).floatValue();
    ay = theOscMessage.get(1).floatValue();  
    az = theOscMessage.get(2).floatValue();  
  }
  
  if (theOscMessage.addrPattern().equals("/acc")) {
    ax = theOscMessage.get(0).floatValue()/9.8f;
    ay = theOscMessage.get(1).floatValue()/9.8f;  
    az = theOscMessage.get(2).floatValue()/9.8f;   
  }

  if (theOscMessage.addrPattern().equals("/ori")) {
    anglex = theOscMessage.get(0).intValue()/180.0f*PI;
    angley = theOscMessage.get(1).intValue()/180.0f*PI;  
    anglez = theOscMessage.get(2).intValue()/180.0f*PI;     
  }  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "OSC_dometest" });
  }
}
