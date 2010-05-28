

PImage img;
float imgOffX;
float imgOffY;
float imgWidth;
float imgHeight;
float imgScale;


void drawImage(PImage img) {
    imgScale = min(float(width)/img.width, float(height)/img.height);
    imgWidth = img.width*imgScale;
    imgHeight = img.height*imgScale;
    imgOffX = (width - imgWidth)/2;
    imgOffY = (height - imgHeight)/2;
    
    image(img,imgOffX,imgOffY,imgWidth,imgHeight);
}

