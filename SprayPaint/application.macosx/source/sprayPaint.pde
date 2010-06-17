
color fillColor;
int spray = 50;
float R = 15;

void setup() {
  size(screen.width,screen.height);
  chooseColor();  
  background(0);
}

void chooseColor() {
 fillColor = color(random(255), random(255), random(255), 200); 
}

void draw() {
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

void keyPressed() {
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


void mousePressed() {
  chooseColor();  
}
