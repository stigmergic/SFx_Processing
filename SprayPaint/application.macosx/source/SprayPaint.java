import processing.core.*; 
import processing.xml.*; 

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

public class SprayPaint extends PApplet {


int fillColor;
int spray = 50;
float R = 15;

public void setup() {
  size(screen.width,screen.height);
  chooseColor();  
  background(0);
}

public void chooseColor() {
 fillColor = color(random(255), random(255), random(255), 200); 
}

public void draw() {
  //noStroke();
  //noFill();
  stroke(fillColor);
  
  if (mousePressed) {
  for (int i=0; i< 100; i++) {
    float a = random(2 * PI);
    float r = random(R);
    
    point(mouseX + cos(a) * r, mouseY + sin(a) * r);
  }
  }
  
  //ellipse(mouseX, mouseY, 10, 10);  
}

public void keyPressed() {
  if (key == 'a') {
    R = max(R - 1, 1);
  }
  if (key == 's') {
    R += 1; 
  }
  if (key == 'z') {
    spray = max(spray - 1, 1);
  }
  if (key == 'x') {
    spray +=1;
  }
  if (key == ' ') {
   background(0);
   
  } 
}


public void mousePressed() {
  chooseColor();  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "SprayPaint" });
  }
}
