/***************************************
 *
 * Camera/Projector Homography solver
 *
 *  Joshua Thorp,  jthorp@redfish.com
 *
 ***************************************/

import cern.colt.matrix.*;
import cern.colt.matrix.linalg.*;
import cern.colt.matrix.doublealgo.*;


boolean wantSparse = false;
int cStep = 0;
ArrayList camPts;
ArrayList prjPts;
float cX,cY;
float bX,bY,numB;
int maxSamples = 10;
int sampleStep = 0;
boolean newPoints = false;
DoubleMatrix2D camToPrjHomography, prjToCamHomography;
DoubleMatrix2D points[] = new DoubleMatrix2D[5];
DoubleMatrix2D bPoints[] = new DoubleMatrix2D[5];
Algebra alg = new Algebra();

void calibrationSetup() {
  camPts = new ArrayList();
  prjPts = new ArrayList(); 
  tintHighlite = RED;
  blankScreen();
}

void calibrationStep() {
  MyBlob blob;
  DoubleMatrix2D point;
  float x1,y1;

  if (cStep == 0) {
    calibrationSetup();
  }
  if (prjPts.size()>4 && newPoints) {
    double scale = 1;
    DoubleMatrix2D pointC,pointP; 

    int choice;
    /*
    scale = 1;
     for (choice = 0; choice<camPts.size(); choice++) {
     camToPrjHomography = getHomography(camPts,prjPts);     
     pointC = (DoubleMatrix2D) camPts.get(choice);
     pointP = (DoubleMatrix2D) prjPts.get(choice);
     pointC = alg.mult(camToPrjHomography, pointC);
     scale *= pointP.get(0,0)/pointC.get(0,0);
     }
     scale = Math.pow(scale, 1.0/ camPts.size());    
     Transform.mult(camToPrjHomography, scale);
     */

    scale = 1;
    for (choice = 0; choice<camPts.size(); choice++) {
      prjToCamHomography = getHomography(prjPts,camPts);
      pointC = (DoubleMatrix2D) camPts.get(choice);
      pointP = (DoubleMatrix2D) prjPts.get(choice);
      pointP = alg.mult(prjToCamHomography, pointP);
      scale *= pointC.get(0,0)/pointP.get(0,0);
    }
    scale = Math.pow(scale, 1.0/ camPts.size());    
    Transform.mult(prjToCamHomography, scale);

    camToPrjHomography = alg.inverse(prjToCamHomography);

    //prjToCamHomography = alg.inverse(camToPrjHomography);
    println("Homography: " + camToPrjHomography);
    newPoints = false;
          if (!showcam) map_pts();

  }

  stroke(200,255,50,100);
  drawX(prjToCamHomography);
  stroke(200,255,255,100);
  drawX(camToPrjHomography);
  cStep += 1;

  if (!showcam) map_pts();
}


DoubleMatrix2D getCamToProj(DoubleMatrix2D point) {
  if (camToPrjHomography == null) return point;
  return alg.mult(camToPrjHomography, point);
}

DoubleMatrix2D getProjToCam(DoubleMatrix2D point) {
  if (camToPrjHomography == null) return point;
  return alg.mult(prjToCamHomography, point);
}


void drawPt(DoubleMatrix2D pt, color c, int radius) {
  float x,y;
  x = (float)pt.get(0,0);  
  y = (float)pt.get(1,0);
  noStroke();
  fill(c);
  ellipse(x,y,radius,radius);  
}

Location getAvgLocationOfBlobs(ArrayList blobs) {
  Location point = new Location();
  MyBlob b;
  for (int i=0; i<blobs.size(); i++) {
    b = (MyBlob) blobs.get(i);
    point.addLocation(b.center());
  }
  point.scale(1.0/blobs.size());
  return point;  
}

void setupPoints() {
  int margin = min(width/4,height/4);
  
  if (points[0] == null) {
    points[0] = getPoint(margin,margin);
    points[1] = getPoint(width - margin,margin);
    points[2] = getPoint(width - margin,height - margin);
    points[3] = getPoint(margin,height - margin);
    points[4] = getPoint(width/2,height/2);
  }    
}

void map_pts() {
  color c;
  int r;
  Location center =new Location(width/2,height/2);
  DoubleMatrix2D point;  
  MyBlob b;
  int choice = 0;
  double distance,minDistance;
  bPoints = new DoubleMatrix2D[5];

  setupPoints();

  if (redBlobs.size() == 5 && !drawimg2) {
    Location avgPt = getAvgLocationOfBlobs(redBlobs);
    for (int i=0; i<redBlobs.size(); i++) {
      b = (MyBlob) redBlobs.get(i);
      point = getPoint(b.centerX()*width-avgPt.x*width+width/2,b.centerY()*height-avgPt.y*height+height/2);    
      minDistance = -1;
      for (int j =0; j<points.length; j++) {
        distance = Math.sqrt(sq(points[j].get(0,0) - point.get(0,0)) + sq(points[j].get(1,0) - point.get(1,0)));
        if (minDistance<0 || distance < minDistance) {
          choice = j;
          minDistance = distance;
        }         
      }
      bPoints[choice] = getPoint(b.centerX()*width,b.centerY()*height);
    }
    boolean blobsDefined = true;
    for (int i=0; i<bPoints.length; i++) {
      if (bPoints[i] == null) blobsDefined = false;
      //println("Blobs Defined: " + blobsDefined + " bPoint: " + i);    
    }    
    if (blobsDefined) {
      c = color(100,100);
      r = 16;
      drawPts(bPoints, c,r);
      drawLines(bPoints,points,c);
      camPts = new ArrayList();
      prjPts = new ArrayList();
      for (int i=0; i<bPoints.length; i++) {
        if (i<4) {
          camPts.add(bPoints[i]);
          prjPts.add(points[i]);
        }
        camPts.add(bPoints[i]);
        prjPts.add(points[i]);

      }
      newPoints = true;  
    }
  }
  r=20;
  if (points[0] != null) {
    c= color(0,0,0);
    drawPts(points,c,r*5);
    c= color(255,0,0);
    drawPts(points,c,r);
  }

}

double sq(double d) { 
  return d*d; 
}

void drawPts(DoubleMatrix2D[] points, color c, int r) {
  for (int i=0; i<points.length; i++) {
    drawPt(points[i],c,r);  
  }
}

void drawLines(DoubleMatrix2D[] points1,DoubleMatrix2D[] points2, color c) {
  for (int i=0; i<points.length; i++) {
    drawLine(points1[i],points2[i],c);  
  }    
}

void drawLine(DoubleMatrix2D pt1, DoubleMatrix2D pt2, color c) {
  stroke(c);
  line((float)pt1.get(0,0),(float)pt1.get(1,0), (float)pt2.get(0,0),(float)pt2.get(1,0)); 
}

void drawX(DoubleMatrix2D homography) {
  float x1,y1,x2,y2,x3,y3,x4,y4;
  //float l = .01, x = width/2, y = height/2;
  float l = 1, x = 0, y = 0;
  Algebra alg = new Algebra();
  DoubleMatrix2D point;
  float xscale=1,yscale=1;

  if (camToPrjHomography != null) {  
    point = getPoint(0,0);
    point = alg.mult(homography,point);
    x1 = (float)point.get(0,0)*xscale;
    y1 = (float)point.get(1,0)*yscale;
    point = getPoint(width,0);
    point = alg.mult(homography,point);
    x2 = (float)point.get(0,0)*xscale;
    y2 = (float)point.get(1,0)*yscale;
    point = getPoint(0,height);
    point = alg.mult(homography,point);
    x3 = (float)point.get(0,0)*xscale;
    y3 = (float)point.get(1,0)*yscale;
    point = getPoint(width,height);
    point = alg.mult(homography,point);
    x4 = (float)point.get(0,0)*xscale;
    y4 = (float)point.get(1,0)*yscale;
    line(x1/l+x,y1/l+y,x2/l+x,y2/l+y);
    line(x1/l+x,y1/l+y,x3/l+x,y3/l+y);
    line(x1/l+x,y1/l+y,x4/l+x,y4/l+y);
    line(x2/l+x,y2/l+y,x3/l+x,y3/l+y);
    line(x2/l+x,y2/l+y,x4/l+x,y4/l+y);
    line(x3/l+x,y3/l+y,x4/l+x,y4/l+y);
  }

}



DoubleFactory2D getFactory() {
  if (wantSparse) return DoubleFactory2D.sparse;
  return DoubleFactory2D.dense;
}

void doMath() {
  DoubleFactory2D factory = getFactory();
  ArrayList camPoints = new ArrayList();
  ArrayList projPoints = new ArrayList();

  camPoints.add(getPoint(0,0));
  projPoints.add(getPoint(1,1));
  camPoints.add(getPoint(1,1));
  projPoints.add(getPoint(0,0));
  camPoints.add(getPoint(1,0));
  projPoints.add(getPoint(0,1));
  camPoints.add(getPoint(0,1));
  projPoints.add(getPoint(1,0));

  println(getMatrix(camPoints));
  println(getMatrix(projPoints));
  println(getHomography(camPoints,projPoints));
}

DoubleMatrix2D getPoint(double x, double y) {
  double[][] d = {
    {
      x                    }
    ,{
      y                    }
    ,{
      1                    }
  };
  return DoubleFactory2D.dense.make(d);
}


DoubleMatrix2D getMatrix(ArrayList points) {
  DoubleMatrix2D point;
  DoubleMatrix2D matrix = null;

  if (points.size()>=1) {
    matrix = (DoubleMatrix2D) points.get(0);
  }
  for (int i=1; i<points.size(); i++) {
    matrix = getFactory().appendColumns(matrix, ((DoubleMatrix2D) points.get(i)));
  }
  println(matrix);
  return matrix;
}

DoubleMatrix2D getHomography(ArrayList cameraPoints, ArrayList projectorPoints) {
  Algebra alg = new Algebra();
  DoubleMatrix2D matrix = null,A,B,L;
  int n = cameraPoints.size();
  A = getMatrix(cameraPoints);
  B = getMatrix(projectorPoints);

  L = getFactory().make(2*n,9);

  for (int i=0; i<n; i++) {
    //X
    L.set(i*2,0,A.get(0,i));   
    L.set(i*2,1,A.get(1,i));   
    L.set(i*2,2,A.get(2,i));   
    L.set(i*2,6,-A.get(0,i)*B.get(0,i));   
    L.set(i*2,7,-A.get(1,i)*B.get(0,i));   
    L.set(i*2,8,-B.get(0,i));   
    //Y
    L.set(i*2+1,3,A.get(0,i));   
    L.set(i*2+1,4,A.get(1,i));   
    L.set(i*2+1,5,A.get(2,i));   
    L.set(i*2+1,6,-A.get(0,i)*B.get(1,i));   
    L.set(i*2+1,7,-A.get(1,i)*B.get(1,i));   
    L.set(i*2+1,8,-B.get(1,i));   
  }

  println(L);

  SingularValueDecomposition svd = new SingularValueDecomposition(L);
  println(svd.getU());
  println(svd.getS());
  println(svd.getV());
  DoubleMatrix1D h = svd.getV().viewColumn(8);

  //DoubleMatrix1D h = (alg.solve(L,getFactory().make(9,1))).viewColumn(0);
  DoubleMatrix2D H = getHfromh(h);


  println(H);
  return H;      
}

DoubleMatrix2D getHfromh(DoubleMatrix1D h) {
  Algebra alg = new Algebra();
  DoubleMatrix2D H = getFactory().make(3,3);
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      H.set(i,j,h.get(i*3+j));
    }
  }
  return H;
}


void findSinglePoint() {
  float x1,y1;
  MyBlob blob;
  DoubleMatrix2D point;
  Algebra alg = new Algebra();

  if (redBlobs.size() == 1) {
    blob = (MyBlob) redBlobs.get(0);
    if (prjToCamHomography != null) {    
      point = getPoint(blob.centerX()*img.width, blob.centerY()*img.height);
      println(point);
      point = alg.mult(prjToCamHomography, point);
      x1 = (float)point.get(0,0);
      y1 = (float)point.get(1,0);
      println ("" + x1 + ", " + y1);
      fill(255,100);
      ellipse(x1,y1,20,20);

      point = getPoint(blob.centerX()*img.width, blob.centerY()*img.height);
      point = alg.mult(camToPrjHomography, point);
      x1 = (float)point.get(0,0);
      y1 = (float)point.get(1,0);
      println ("" + x1 + ", " + y1);
      ellipse(x1,y1,20,20);    
    }

    if (cStep % 10 > 1) {
      bX += blob.centerX();
      bY += blob.centerY();
      numB += 1;  
    }

    if (cStep % 10 == 9 && numB>0 && !showcam) {
      point = getPoint(bX/numB*img.width,bY/numB*img.height);
      camPts.add(point);
      prjPts.add(getPoint(cX,cY));
      println("Added calibration points: " + camPts.get(camPts.size()-1) + " " + prjPts.get(prjPts.size()-1));
      if (camPts.size()>maxSamples) {
        camPts.remove(0);
        prjPts.remove(0); 
      }


    }    

  }

  fill(255,0,0);
  noStroke();
  //ellipse(cX,cY,12,12);

  if (cStep % 10 == 0) {
    bX = 0;
    bY = 0; 
    numB = 0;

  }

}
