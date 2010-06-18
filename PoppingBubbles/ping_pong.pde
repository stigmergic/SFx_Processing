//float constrain(float val, float minVal, float maxVal) {
//  return min(maxVal, max(minVal, val));  
//}

Location left, right, ball;
float pLength = 250, pWidth = 20;
int leftScore = 0, rightScore = 0;

void draw_paddle(float x, float y) {
  float ny = constrain(y, pLength/2, height - pLength/2);
  noStroke();
  fill(200);
  rect(x-pWidth/2, ny-pLength/2, pWidth, pLength);  
} 

void draw_field() {
  noStroke();
  fill(200);
  rect(0, height-pWidth, width, pWidth);
  fill(100);
  rect(width/2-pWidth/4,0,pWidth/2,height);      
}

void setup_ping_pong() {
  left = new Location();
  left.x = 0;
  left.y = height/2;
  right = new Location();
  right.x = width;
  right.y = height/2;  
  crt_new_ball();
}

void crt_new_ball() {
  ball = new Location();
  ball.x = width/2;
  ball.y = height/2;
  ball.radius = 20;
  ball.dirX = (random(1) - 0.5) * 50 + 50;
  ball.dirY = (random(1) - 0.5) * 100;
  if (random(1)>=0.5) ball.dirX *= -1;
  ball.g = 100;
  ball.r = 100;  
}

void draw_ball() {
  if (!drawgrayscale)
  fill(ball.r, ball.g, ball.b);
  else fill(255,0,0);
  noStroke();
  ellipse(ball.x,ball.y,ball.radius, ball.radius);  
}

void move_ball() {
        
        ball.y += ball.dirY;
        ball.x += ball.dirX;

       if (ball.y+ball.radius>height-pWidth) {
            ball.y = height-ball.radius-pWidth;
            ball.dirY = -1 * sign(ball.dirY) * min (0.125*height, abs(ball.dirY*1.1));
            ball.g +=10;
            bounce_sound(ball.x/width);
          }
        
       if (ball.y-ball.radius-pWidth<0) {
          ball.y = ball.radius+pWidth;
          ball.dirY = -1 * sign(ball.dirY) * min (0.125*height, abs(ball.dirY*1.1));
          ball.g +=10;
            bounce_sound(ball.x/width);
          }
        
        if (ball.x+ball.radius>width-pWidth) {
          if (abs(ball.y-right.y)>pLength/2) {
            crt_new_ball();
            leftScore += 1;
          } else {
          ball.x = width-ball.radius;
          ball.dirX = -1 * sign(ball.dirX) * max (50, min (00.125*width, abs(ball.dirX*1.1)));
          ball.b +=10;
            bounce_sound(ball.x/width);
            
          }
                }
       if (ball.x-ball.radius<pWidth) {
          if (abs(ball.y-left.y)>pLength/2) {
            crt_new_ball();
            rightScore += 1;
          } else {
       ball.x = ball.radius;
            ball.dirX = -1 * sign(ball.dirX) * max(50, min (0.125*width, abs(ball.dirX*1.1)));
            
                   ball.b +=10;
            bounce_sound(ball.x/width);
          }
                }
 
}

Location find_blob_center(MyBlob bb) {
  Location l = new Location();
  DoubleMatrix2D point = getPoint( width*bb.centerX() , height*bb.centerY() );
  point  = getCamToProj(point);
  l.x =(float) point.get(0,0);
  l.y = (float) point.get(1,0);
  return l;
}


Location find_near_blob(float x, float maxDist) {
  MyBlob b,bb;
  Location l, bl = null;
 
  
  float d,bd = -1;
    for (int i=0; i<redBlobs.size(); i++) {
     b = (MyBlob) redBlobs.get(i);
     l = find_blob_center(b);
     d = abs(l.x-x);
     if (d<maxDist && (d < bd || bd < 0)) {
       bd = d;
       bl = l;  
     }
  }
  
  return bl;
} 

void drawLine(Location loc1, Location loc2) {
    strokeWeight(2);
    stroke(100,100,25,150);
    line(loc1.x,loc1.y,loc2.x,loc2.y);
  
}

void move_near_blobs() {
  Location l;
  l = find_near_blob(left.x, 400);
  if (l != null) {
    left.y = constrain(l.y, pLength/2, height - pLength/2);
    left.x = constrain(l.x, 0, 400);
    drawLine(left,l);
  }
  l = find_near_blob(right.x, 400);
  if (l != null) {
    right.y = constrain(l.y, pLength/2, height - pLength/2);
    right.x = constrain(l.x, width - 400, width);
    drawLine(right,l);
  }
      
}

void draw_score() {
  font = loadFont("SynchroLET-48.vlw"); 
  int xmargin = 200;
  int ymargin = height - 50;
  textFont(font, 64);
  fill(80,100,60);
  String leftStr = leftScore<10 ? "00" + leftScore : leftScore<100 ? "0"+leftScore : "" + leftScore; 
  String rightStr = rightScore<10 ? "00" + rightScore : rightScore<100 ? "0"+rightScore : "" + rightScore; 
  text(leftStr, xmargin, ymargin);
  text(rightStr, width - textWidth(rightStr) - xmargin, ymargin);
    
}

void ping_pong_step() {
  if (left == null || right == null) setup_ping_pong();
  if (new_ball) {
    crt_new_ball();
    new_ball = false;
  }
  
  move_near_blobs();
  move_ball();
  draw_paddle(left.x, left.y);
  draw_paddle(right.x, right.y); 
  draw_field();
  draw_ball(); 
  draw_score();
}
