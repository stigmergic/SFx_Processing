  public void drawFoundRect(float x, float y, float z, float angle) {
        pushMatrix();
        translate(x*width,y*height);
      rotate(angle);
      if (drawtinted) {
        //image(img2,- img2.width/2,-img2.height/2);
      }  else {
      //color [] cColors = { color(255,255,255), color(255,0,0), color(0,255,0), color(0,0,255) };
      //color rectColor = cColors[tintHighlite]; 
      noStroke();
      color rectColor;
      if (tintHighlite == 0) {
      fill(255,255,255, 80);  
      } else if (tintHighlite == 1) {
      fill(255,0,0, 80);  
      } else if  (tintHighlite == 2) {
      fill(0,255,0, 80);  
      } else {
      fill(0,0,255, 80);  
      }
      rect(- img.width/2,-img.height/2, img.width, img.height);
    }   
    popMatrix();
  }

    float[] process_blob(Blob bb){
    // USE THE BIG BLOB TO FIGURE OUT 4D MOUSE VALUES
    float[][][] returned = find_quad(bb);
    float[][] rbbox = returned[1];
    float angle = returned[0][0][0];
    float area = returned[0][1][0]; // sloppy_area(rbbox);

    // MOUSE POS COMES FROM THE CENTER OF THE BIG BLOB
    float mx = (rbbox[0][0]+rbbox[1][0]+rbbox[2][0]+rbbox[3][0])/4;
    float my = (rbbox[0][1]+rbbox[1][1]+rbbox[2][1]+rbbox[3][1])/4;

    // MAKE THE BORDERS REACHABLE
    if(bb!=null){
      //mx = mx*(1+bb.w*2)-bb.w;
      //my = my*(1+bb.h*2)-bb.h;
    }
    // KEEP MOUSE WITHIN BOUNDARIES
    mx = max(0,min(1,mx));
    my = max(0,min(1,my));  


    // DRAW THE POINTER
    float mr = 5;
    strokeWeight(3);
    stroke(255,0,0); 
    ellipse(width*mx-mr,height*my-mr,mr,mr);


  return new float[]{
    mx,my,area,angle        };
}

float[][][] find_quad(Blob bb){
  //
  // FIND THE CORNERS, ROTATION, AND AREA OF THE SCREEN (IN THE CAMERA IMAGE)
  //
  float[][] original_box = {
    {
      -1,0                            }
    ,{
      -1,1                            }
    ,{
      1,1                            }
    ,{
      1,0                            }
  };
  float[][] bestCoords = original_box;
  float[][] bestBox = original_box;
  float bestArea = 0;
  float bestAngle = 0;
  float[][] half;

  if(bb!=null){
    // GET VERTICES FROM BLOB PERIMETER
    float[][] coords = new float[bb.getEdgeNb()][2];
    float[] centroid = { 0,0};
    for (int m=0;m<bb.getEdgeNb();m++)
    {
      coords[m][0] = bb.getEdgeVertexA(m).x;
      coords[m][1] = bb.getEdgeVertexA(m).y;

        }

       centroid[0] = (bb.xMin + bb.xMax)/2;
       centroid[1] = (bb.yMin + bb.yMax)/2;
 
         //centroid[0] = 0.5;
         //centroid[1] = 0.5;


    // FIGURE OUT THE FOUR CORNERS OF THE SCREEN
    for(float angle=-1.571; angle<1.571; angle+=.1){
      // ROTATE A 'PROTOTYPE' RECTANGLE
      half = scalepts(rotatepts(original_box, angle, centroid),0.25,centroid);
      // GET THE CLOSEST POINTS TO THE CORNERS OF THAT 'PROTOTYPE' RECTANGLE
      float[][] bbox = find_corners(coords, half);
      // MEASURE THE ARE OF THAT QUAD
      float thisArea = sloppy_area(bbox);
      // THE BEST QUAD IS THE ONE WITH THE BIGGEST AREA
      if(thisArea > bestArea){
        bestArea = thisArea;
        bestCoords = bbox;
        bestAngle = angle;
        bestBox = half;
      }
    }
 drawBox(bestCoords, color(255,0,255,100));
  //drawBox(bestBox, color(0,100,0,100));

  }
  //float[][][] returned = {{{bestAngle},{bestArea}}, bestCoords};
  return new float[][][] {
    {
      {
        bestAngle                                          }
      ,{
        bestArea                                          }
    }
    , bestCoords              };
}

void drawBox(float[][] bestCoords, color lineColor) {

    // DRAW THE BORDER OF THE SCREEN
    strokeWeight(2);
    stroke(lineColor);
    for(int i=0;i<3; i++){
      line(width*bestCoords[i][0], height*bestCoords[i][1], width*bestCoords[i+1][0], height*bestCoords[i+1][1]);
    }
    line(width*bestCoords[0][0], height*bestCoords[0][1], width*bestCoords[3][0], height*bestCoords[3][1]);

    // DRAW THE FOUR CORNERS OF THE SCREEN
    stroke(255,255,255);
    for (int m=0;m<4;m++)
    {
      //ellipse(width*bestCoords[m][0],height*bestCoords[m][1],5,5);
    }
}


float sloppy_area(float[][] corn){
  float a = dist(corn[0][0],corn[0][1], corn[1][0], corn[1][1]);
  float b = dist(corn[1][0],corn[1][1], corn[2][0], corn[2][1]);
  float c = dist(corn[2][0],corn[2][1], corn[3][0], corn[3][1]);
  float d = dist(corn[3][0],corn[3][1], corn[0][0], corn[0][1]);
  return (a*b + b*c + c*d + d*a)/4;
}

float[] rotation(float x, float y, float theta){
  float[] xy = {
    x*cos(theta) - y*sin(theta),
    x*sin(theta) + y*cos(theta)                                    };
  return xy;
}

float[][] rotatepts(float[][] pts, float theta, float[] centroid){
  float[][] newpts = new float[pts.length][pts[0].length];
  for(int i=0; i<newpts.length; i++){
    newpts[i] = rotation(pts[i][0]-centroid[0], pts[i][1]-centroid[1], theta);
  }
  for(int i=0; i<newpts.length; i++){
    newpts[i][0] += centroid[0];
    newpts[i][1] += centroid[1];
  }
  return newpts;
}

float[][] scalepts(float[][] pts, float factor, float[] centroid){
  float[][] newpts = new float[pts.length][pts[0].length];
  for(int i=0; i<newpts.length; i++){
    newpts[i][0] = (pts[i][0]-centroid[0])*factor+centroid[0];
    newpts[i][1] = (pts[i][1]-centroid[1])*factor+centroid[1];
  }
  return newpts;
}

float[][] translatepts(float[][] pts, float[] centroid) {
 float[][] newpts = new float[pts.length][pts[0].length];
  for(int i=0; i<newpts.length; i++){
    newpts[i][0] = pts[i][0]+centroid[0];
    newpts[i][1] = pts[i][1]+centroid[1];
    println(""+newpts[i][0]+", "+newpts[i][1]);
  }
  return newpts;

}

float[] closetopt(float[][] coords, float[] pt){
  float mindist = 9999999;
  float[] closest = {
    0,0                                };
  for(int i=0; i<coords.length; i++){
    float dd = dist(coords[i][0], coords[i][1], pt[0], pt[1]) ;
    if( dd < mindist){
      mindist = dd;
      closest[0] = coords[i][0];
      closest[1] = coords[i][1];
    }
  }
  return closest;
}

float[][] find_corners(float[][] coords, float[][] corners){
  // find closest point to corner A
  float[] A = closetopt(coords, corners[0]);
  // find closest point to corner B
  float[] B = closetopt(coords, corners[1]);
  // find closest point to corner C
  float[] C = closetopt(coords, corners[2]);
  // find closest point to corner D
  float[] D = closetopt(coords, corners[3]);

  float[][] f = {
    A,B,C,D                                };
  return f;
}
