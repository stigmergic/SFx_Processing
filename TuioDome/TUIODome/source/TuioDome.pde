
import tuio.*;
TuioClient tuioClient;

float cursor_size = 10;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;

PFont font;

float centerX, centerY;
float a = 0;
float da = PI/16;



void setup()
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
void draw()
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
    color c1 = getColor(i);
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

